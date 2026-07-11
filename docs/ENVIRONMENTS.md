# Environments & Release Workflow

From now on: **build and test on pre-prod first, then deploy to prod.** Nothing goes to live users
until it has been verified locally.

There are **two environments** (one codebase, two configs — NOT two copies of the repo; duplicating
the folder causes drift, which is why `Salone` vs `Salone2` is already confusing).

---

## 1. Pre-prod — local, on this machine (where we test)

Runs the backend on your PC with a local database. The phone connects to it over USB. Nothing here
touches live salon data.

**Config:** `backend/.env` (already present) — relaxed for convenience because it's localhost-only:
`AUTH_REQUIRED=false`, `DEMO_AUTH_ENABLED=true`, local `DATABASE_URL`. **These relaxed values are for
local only and must never appear in prod.**

### Start it
```bash
# 1. Start Docker Desktop first (the daemon must be running).
cd backend

# 2. Bring up local Postgres + Redis only (not the api service — we run that with hot-reload):
docker compose up -d postgres redis

# 3. Create the schema and seed demo data (first time / after schema changes):
npm run prisma:generate
npx prisma db push          # or: npm run prisma:migrate
npm run prisma:seed:demo    # login 9000000001 / glamour123

# 4. Run the backend with hot-reload:
npm run dev                 # http://localhost:3000
curl http://localhost:3000/health   # {"status":"ok",...}
```

### Point the phone at local pre-prod
The app's API URL is a build-time flag (`main.dart`: `API_URL`, default `http://10.0.2.2:3000`).
For a physical phone over USB:
```bash
adb reverse tcp:3000 tcp:3000    # phone's localhost:3000 -> your PC's :3000
cd mobile/salon_admin_app_v2
flutter run --dart-define=API_URL=http://localhost:3000
# or a test APK: flutter build apk --release --dart-define=API_URL=http://localhost:3000
```
Now the app talks to your local backend. Break things freely here.

---

## 2. Prod — live (where real salons are)

- API: **https://api.slotvibe.buzz** (Kubernetes, ArgoCD, GHCR images).
- Real customer data. Play Store reviewers and testers hit this.

**Prod config is the opposite of local — fail-closed and non-negotiable** (see memory
`backend-auth-hardening` and the 2026-07-09 incident):
```
AUTH_REQUIRED=true
DEMO_AUTH_ENABLED=false
JWT_SECRET=<32+ random chars>
NODE_ENV=production
```
The production app build points at `https://api.slotvibe.buzz` (the default when no `API_URL` override
is passed for release, per the store build command already in use).

---

## The workflow (for Codex and future sessions)

1. **Make the change** on a branch.
2. **Test on pre-prod (local)** — run the backend locally, connect the phone, verify the feature end to
   end (not just typecheck). Fix until it actually works.
3. **Only then deploy to prod** — commit/push, GHCR builds, pin the image in `deploy/k8s/salone-api.yaml`,
   ArgoCD sync. Confirm the exact commit SHA synced (a prior run silently stayed on the old commit).
4. **Verify on prod** with the endpoint checks (health, auth 401 on no token, login works).

**Never** deploy a change straight to prod without the pre-prod pass. **Never** let a relaxed local env
var (`AUTH_REQUIRED=false`, `DEMO_AUTH_ENABLED=true`, short `JWT_SECRET`) reach the prod deployment.

### Note on the `api` service in docker-compose.yml
That service sets `JWT_SECRET: changeme` and runs `prisma db push --accept-data-loss`. It is a
**local convenience only**. With the current fail-closed auth code it would actually crash if auth is
enforced (secret too short), so for local dev run Postgres/Redis from compose and the API via
`npm run dev` with `.env` (as above). Do not use that compose `api` service as a prod template.
