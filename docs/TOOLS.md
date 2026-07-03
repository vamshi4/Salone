# Agent Tooling

This repo uses a small set of agent helpers to reduce repeated context loading and improve UI quality.

## Installed

### Ponytail

Project skills are installed in `.agents/skills/`.

Use it as the default coding posture:

- Make the smallest useful change.
- Prefer existing app patterns.
- Avoid new packages unless they remove real complexity.
- Finish one screen or flow properly before spreading changes across many areas.

### Impeccable

Project skills/hooks are installed in `.agents/skills/impeccable`, `.codex/hooks.json`, and `.cursor/hooks.json`.

Use it for customer, stylist, and salon admin UI work:

- Check spacing, alignment, typography, and empty/error states.
- Keep app screens functional, not landing-page styled.
- Prefer clear actions and complete states over decorative polish.
- Avoid placeholder-looking UI after a screen is touched.

## Pending / Optional

### Graphify

Goal: generate a project graph/report so agents can understand backend/mobile structure without rereading the whole repo.

Status: install was attempted, but Python failed because the C drive was full. Retry only after C has enough free space or after Python cache/site packages are redirected to D.

Recommended output folder: `graphify-output/`.

### RTK

Goal: compact noisy terminal output before sending it into AI context.

Status: not installed yet. Use only as a helper for long build/test logs; do not replace direct file inspection when debugging exact code.

Recommended output folder: `rtk-output/`.

## Practical Rule

For normal app work:

1. Read `AGENTS.md`, `PRODUCT.md`, `DESIGN.md`, and the relevant app files.
2. Use Ponytail for scope control.
3. Use Impeccable for UI screens.
4. Use Graphify/RTK only when they save context, not as required ceremony.
