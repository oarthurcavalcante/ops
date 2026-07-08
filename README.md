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

Everything autosaves to the browser's local storage on the machine where you open it.
**Data lives in the browser, not in this file** — committing a new version of the HTML never touches your tasks.

Use **Export** (top right) to download a JSON backup, **Import** to restore it. Committing the exported JSON to this repo is a good habit if you work across devices.

### Updating backups in the repo

1. Export from the dashboard (top right).
2. Save the file as `backups/YYYY-MM-DD.json`.
3. Copy the same file to `backups/latest.json`.
4. Commit and push.

The dashboard and latest-backup links above do not change — only the content they serve updates.

## Updating the dashboard

The dashboard is one self-contained HTML file (`index.html`). To change features or layout, give the current file to Claude, describe the change, and commit the returned file.

## Versions

- v1.0 — initial dashboard: 7 phases, macro/micro views, tasks, subtasks, notes, due dates, drag & drop, export/import.
