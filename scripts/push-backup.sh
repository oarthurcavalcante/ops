#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
BACKUPS="$ROOT/backups"
LATEST="$BACKUPS/latest.json"

# Avoid stale GH_TOKEN overriding keyring auth (common on macOS).
unset GH_TOKEN

usage() {
  cat <<'EOF'
Push the latest dashboard backup to GitHub.

Usage:
  ./scripts/push-backup.sh                 Use the newest file in backups/ (except latest.json)
  ./scripts/push-backup.sh <file.json>     Use a specific backup file

Workflow:
  1. Export from the dashboard
  2. Save the file into backups/
  3. Run this script
EOF
}

pick_newest_backup() {
  local newest="" mtime=0 f base m
  shopt -s nullglob
  for f in "$BACKUPS"/*.json; do
    base="$(basename "$f")"
    if [ "$base" = "latest.json" ]; then
      continue
    fi
    m="$(stat -f %m "$f" 2>/dev/null || stat -c %Y "$f")"
    if [ "$m" -gt "$mtime" ]; then
      mtime=$m
      newest=$f
    fi
  done
  shopt -u nullglob
  if [ -z "$newest" ]; then
    return 1
  fi
  printf '%s\n' "$newest"
}

validate_backup() {
  python3 -c 'import json,sys; p=sys.argv[1]; d=json.load(open(p,encoding="utf-8")); sys.exit(0 if isinstance(d.get("phases"),list) and d["phases"] else 1)' "$1" \
    || { echo "Invalid backup (missing phases): $1" >&2; exit 1; }
}

resolve_source() {
  local arg="${1:-}"

  if [ -n "$arg" ]; then
    if [ -f "$arg" ]; then
      printf '%s\n' "$(cd "$(dirname "$arg")" && pwd)/$(basename "$arg")"
      return 0
    fi
    if [ -f "$BACKUPS/$arg" ]; then
      printf '%s\n' "$BACKUPS/$arg"
      return 0
    fi
    echo "Backup not found: $arg" >&2
    return 1
  fi

  pick_newest_backup
}

backup_label() {
  local file="$1" base label
  base="$(basename "$file" .json)"
  label="${base#ops-dashboard-backup-}"

  case "$label" in
    [0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]) printf '%s\n' "$label" ;;
    *) case "$base" in
         [0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]) printf '%s\n' "$base" ;;
         *) date -r "$(stat -f %m "$file" 2>/dev/null || stat -c %Y "$file")" +%Y-%m-%d ;;
       esac ;;
  esac
}

main() {
  if [ "${1:-}" = "-h" ] || [ "${1:-}" = "--help" ]; then
    usage
    exit 0
  fi

  mkdir -p "$BACKUPS"

  local source label
  if ! source="$(resolve_source "${1:-}")"; then
    echo "No backup found in $BACKUPS" >&2
    echo "Export from the dashboard, save the file into backups/, then run this script again." >&2
    exit 1
  fi

  validate_backup "$source"
  label="$(backup_label "$source")"

  cp "$source" "$LATEST"

  cd "$ROOT"
  git add "$LATEST"

  if git diff --cached --quiet; then
    echo "Already up to date: backups/latest.json matches $(basename "$source")"
    exit 0
  fi

  git commit -m "Update dashboard backup ($label)."
  git push origin main

  echo "Pushed backups/latest.json from $(basename "$source")"
  echo "Dashboard: https://oarthurcavalcante.github.io/ops/"
}

main "$@"
