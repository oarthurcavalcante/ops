# OPS — Business Command Center

Single-file dashboard for running the faceless info-product business, phase by phase.

## Live links (stable URLs)

These URLs stay the same as you update the repo. GitHub Pages always serves the latest commit on `main`.

| What | URL |
|------|-----|
| **Dashboard** | https://oarthurcavalcante.github.io/ops/ |
| **Latest backup** | https://oarthurcavalcante.github.io/ops/backups/latest.json |

Dated snapshots live in [`backups/`](backups/) (e.g. `2026-07-08.json`). When you add a new backup, copy it to `backups/latest.json` so the latest link always reflects your current data.

## Use locally

Open [`index.html`](index.html) in any browser. No install, no server, no dependencies.

- **Macro view** — the whole pipeline: Problem → Product Development → Product Distribution → Content Distribution → Ads → Checkout → Automation. Progress per phase, overdue counts, drag to reorder.
- **Micro view** — click a phase: tasks with checkboxes, due dates, priorities, notes, subtasks, drag-to-reorder, move between phases.

## Data

While you work, changes autosave to your browser's local storage. When you open the live link, the dashboard **automatically fetches `backups/latest.json` from the repo** and syncs to it.

### End-of-session workflow

1. Click **Export** (top right) to download your JSON backup.
2. Save the file into [`backups/`](backups/) (e.g. `2026-07-08.json` or keep the export name).
3. Run:

```bash
./scripts/push-backup.sh
```

The script picks the newest file in `backups/`, copies it to `backups/latest.json`, commits, and pushes to `main`. To push a specific file instead:

```bash
./scripts/push-backup.sh backups/2026-07-08.json
```

Next time you open https://oarthurcavalcante.github.io/ops/, your tasks load from the latest backup automatically.

Use **Import** only if you need to restore from a different file manually.

## Updating the dashboard

The dashboard is one self-contained HTML file (`index.html`). To change features or layout, give the current file to Claude, describe the change, and commit the returned file.

## Versions

- v1.0 — initial dashboard: 7 phases, macro/micro views, tasks, subtasks, notes, due dates, drag & drop, export/import.
