# Salone Agent Instructions

Use this file as the first context for Codex, Cursor, Meta AI, and any other coding agent working on Salone.

## Project

Salone/GlamBook is a salon and stylist marketplace with:

- Backend: `backend/`
- Customer app: `mobile/customer_app/`
- Stylist app: `mobile/stylist_app/`
- Salon admin app: `mobile/salon_admin_app/`

Do not create a new app or restart the project. Continue from the existing code.

## Working Style

- Be brief. Do the work, then report only what changed and what passed.
- Prefer small patches over rewrites.
- Reuse existing code and UI patterns before adding packages.
- Do not add dependencies unless they clearly reduce real complexity.
- Preserve demo flow until real auth is intentionally implemented.
- Commit and push verified work when asked or when completing a feature.

## Verification

Backend:

```powershell
cd backend
npm run build
```

Flutter apps:

```powershell
cd mobile/customer_app
flutter analyze

cd ../stylist_app
flutter analyze

cd ../salon_admin_app
flutter analyze
```

Physical Android device:

```powershell
flutter run -d ed083e3d --dart-define=API_URL=http://YOUR_PC_IP:3000
```

`YOUR_PC_IP` must be the current Wi-Fi IPv4 of the backend machine. Do not type placeholder text like `NEW_PC_IP`.

## Current Business Flow

1. Customer discovers salon/stylist.
2. Customer selects service(s), time, and location.
3. Booking starts as `PENDING`.
4. Stylist or salon admin confirms/rejects.
5. Customer can request reschedule after confirmation.
6. Stylist/admin can accept/reject customer reschedule.
7. Stylist can propose reschedule.
8. Customer can accept/reject stylist proposal.

Rejecting a reschedule keeps the original confirmed booking. It must not cancel the booking unless the user explicitly cancels.

## Agent Tool Preferences

- Ponytail principle: reuse, native/simple first, only add minimum needed.
- Impeccable principle: product UI should be quiet, usable, aligned, and not AI-template-looking.
- Graphify/CodeGraph principle: prefer project maps and targeted queries over rereading many files.
- RTK principle: use compact command output for noisy commands, but use exact files/logs when debugging needs precision.

## graphify

This project has a knowledge graph at graphify-out/ with god nodes, community structure, and cross-file relationships.

When the user types `/graphify`, use the installed graphify skill or instructions before doing anything else.

Rules:
- For codebase questions, first run `graphify query "<question>"` when graphify-out/graph.json exists. Use `graphify path "<A>" "<B>"` for relationships and `graphify explain "<concept>"` for focused concepts. These return a scoped subgraph, usually much smaller than GRAPH_REPORT.md or raw grep output.
- Dirty graphify-out/ files are expected after hooks or incremental updates; dirty graph files are not a reason to skip graphify. Only skip graphify if the task is about stale or incorrect graph output, or the user explicitly says not to use it.
- If graphify-out/wiki/index.md exists, use it for broad navigation instead of raw source browsing.
- Read graphify-out/GRAPH_REPORT.md only for broad architecture review or when query/path/explain do not surface enough context.
- After modifying code, run `graphify update .` to keep the graph current (AST-only, no API cost).
