# Deploy Handoff — Build 5 (walk-in, autocomplete, earnings)

Deploy the **backend to prod FIRST**, verify, then publish the app. The app build
(`Chairful-2.0.0-b5.aab`) points at `https://api.slotvibe.buzz` and its new features
will error until the backend below is live.

## What's new since the last prod deploy
On `main` (commits `61a4d62`, `b910fbe`, `3ac2e39`, `269a265`):

**Schema** (`backend/prisma/schema.prisma`)
- `Booking.completedAt DateTime?` — new column, drives earnings.
  (Also present: `deletedAt` on User/Salon/Stylist and the `AdminAuditLog` model from the
  admin-CRUD work — make sure the prod DB has all of these; see step 2.)

**Backend** (`backend/src/routes/`)
- `booking.routes.ts` — `salon-manual` accepts `completed: true`: skips slot validation, stamps
  the server's current time, sets `status=COMPLETED` + `completedAt`.
- `salon.routes.ts` — two new SALON_OWNER/SUPER_ADMIN endpoints:
  - `GET /api/v2/salons/:salonId/customers` — distinct past customers (autocomplete).
  - `GET /api/v2/salons/:salonId/earnings?period=day|week|month` — earnings totals + daily
    breakdown + recent completed services (IST day buckets).

All of the above was built and verified on local pre-prod (`docs/ENVIRONMENTS.md`). Backend
`npx tsc --noEmit` is clean.

## Deploy steps (prod)

1. **Pull latest `main`** and confirm it's at `269a265` (or later) and typechecks:
   ```bash
   git pull
   cd backend && npx tsc --noEmit    # must be clean
   ```

2. **Ensure the prod DB has the new columns.** Prod applies schema via
   `prisma db push` in the deploy path (k8s initContainer), which is idempotent and will add
   `Booking.completedAt` (and any missing `deletedAt` columns / `AdminAuditLog` table). Confirm
   the initContainer in `deploy/k8s/salone-api.yaml` still runs `npx prisma db push` before
   `npm start`. (Do NOT switch to `migrate deploy` — the repo's migration history has a baseline
   gap and previously hit P3009. `db push` is the working mechanism.)

3. **Build & publish the image, then roll it:**
   ```bash
   git push                          # triggers the GHCR image build
   # wait for the GHCR build to finish for the new commit SHA
   # pin the new image tag in deploy/k8s/salone-api.yaml
   git add deploy/k8s/salone-api.yaml && git commit -m "deploy: build 5 backend" && git push
   # ArgoCD sync -> IMPORTANT: sync to the exact new commit SHA
   ```
   Last time ArgoCD silently stayed on the old commit because of a wrong sync revision —
   double-check the synced revision matches the commit you just pushed.

4. **Verify on prod** (get a token via the review account: `9999900000` / `Review@2026`,
   role `SALON_OWNER`):
   ```bash
   API=https://api.slotvibe.buzz
   TOK=$(curl -s --ssl-no-revoke -X POST $API/api/v2/auth/login -H "Content-Type: application/json" \
     -d '{"phone":"9999900000","password":"Review@2026","role":"SALON_OWNER"}' | jq -r .token)
   SALON=<that owner's salon id>   # from GET /api/v2/salons with the token

   # new endpoints must be 200:
   curl -s --ssl-no-revoke "$API/api/v2/salons/$SALON/earnings?period=day"  -H "Authorization: Bearer $TOK" -o /dev/null -w "earnings %{http_code}\n"
   curl -s --ssl-no-revoke "$API/api/v2/salons/$SALON/customers"            -H "Authorization: Bearer $TOK" -o /dev/null -w "customers %{http_code}\n"

   # security must still hold:
   curl -s --ssl-no-revoke "$API/api/v2/salons" -o /dev/null -w "unauth salons %{http_code} (want 401)\n"
   ```
   Expected: `earnings 200`, `customers 200`, `unauth salons 401`.

   Also smoke-test a walk-in create (`POST /v2/bookings/salon-manual` with `completed:true`, no
   `dateTime`) → expect 201 with `status:"COMPLETED"` and a `completedAt`.

## After backend is verified — publish the app
- Upload **`Chairful-2.0.0-b5.aab`** to Play Console → Internal testing → new release.
- (Direct install: **`Chairful-2.0.0-b5-arm64.apk`**.)
- Do NOT publish the app before step 4 passes, or "Done service" / earnings / autocomplete
  will fail for testers against prod.

## Still open (unrelated to this deploy, but pending)
- Access-log breach check from the 2026-07-09 open-API incident (see memory
  `backend-auth-hardening`).
- Super-admin dashboard: `prisma/create-super-admin.ts` + verify `/admin` end to end.
