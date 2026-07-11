# Super-Admin Console — Create & Verify Runbook

Operator steps to (1) create the first SUPER_ADMIN and (2) walk the section-4 verification from
[`ADMIN-CRUD-SPEC.md`](./ADMIN-CRUD-SPEC.md). Run against **pre-prod (local) first, then prod.**

- Pre-prod base: `http://localhost:3000`
- Prod base: `https://api.slotvibe.buzz`

Commands are `curl` + optional `jq` (Git Bash / any POSIX shell). Replace `<...>` placeholders.
Nothing here is destructive to *real* data except the salon/booking you deliberately pick — use a
throwaway/test salon on prod.

---

## 0. Prerequisites

- The `admin_crud` schema (the `deletedAt` columns + `AdminAuditLog`) must be present in the target DB.
  Prod applies schema with `prisma db push` (see STATUS.md item 2 — do the migration reconcile there
  before ever switching to `migrate deploy`).
- You can reach the API and have shell access to the backend (to run the create-admin script).

---

## 1. Create the first SUPER_ADMIN

From the backend host/dir, pointed at the target DATABASE_URL:

```
cd backend
npx tsx prisma/create-super-admin.ts <phone> <password> "Platform Admin"
# or: SUPER_ADMIN_PHONE=<phone> SUPER_ADMIN_PASSWORD=<password> npx tsx prisma/create-super-admin.ts
```

- Password min 12 chars. Idempotent (re-running promotes + resets). Password is never printed.
- Expect: `SUPER_ADMIN ready: id=... phone=... name=...`

Set up shell vars for the rest:

```
BASE=https://api.slotvibe.buzz        # or http://localhost:3000
PHONE=<phone>
PASS=<password>
```

---

## 2. Log in, capture token + your own id

```
LOGIN=$(curl -s -X POST "$BASE/api/v2/auth/login" \
  -H 'Content-Type: application/json' \
  -d "{\"phone\":\"$PHONE\",\"password\":\"$PASS\",\"role\":\"SUPER_ADMIN\"}")
echo "$LOGIN" | jq .
TOKEN=$(echo "$LOGIN" | jq -r .token)
ME=$(echo "$LOGIN" | jq -r .user.id)
AUTH="Authorization: Bearer $TOKEN"
```

✅ You get a `token` and `user.id`. If 401 → wrong creds/role.

---

## 3. Checklist

### [ ] Guard intact — no token → 401
```
curl -s -o /dev/null -w "%{http_code}\n" "$BASE/api/v2/admin/salons"      # expect 401
curl -s -o /dev/null -w "%{http_code}\n" -H "$AUTH" "$BASE/api/v2/admin/salons"  # expect 200
```

Pick a test salon + its owner:
```
SID=$(curl -s -H "$AUTH" "$BASE/api/v2/admin/salons" | jq -r '.[0].id')
OWNER=$(curl -s -H "$AUTH" "$BASE/api/v2/admin/salons/$SID" | jq -r '.salon.owner.id')
echo "salon=$SID owner=$OWNER"
```

### [ ] Edit a salon's plan → reflected + audit row exists
```
curl -s -X PATCH -H "$AUTH" -H 'Content-Type: application/json' \
  -d '{"saasPlan":"PREMIUM"}' "$BASE/api/v2/admin/salons/$SID" | jq .
curl -s -H "$AUTH" "$BASE/api/v2/admin/salons" | jq -r ".[] | select(.id==\"$SID\") | .saasPlan"   # PREMIUM
curl -s -H "$AUTH" "$BASE/api/v2/admin/audit?targetType=Salon&targetId=$SID" | jq '.[0].action'   # "salon.update"
```

### [ ] Soft-delete a salon → gone from admin list AND app-facing, then restore → reappears
```
curl -s -X DELETE -H "$AUTH" "$BASE/api/v2/admin/salons/$SID" | jq .
curl -s -H "$AUTH" "$BASE/api/v2/admin/salons" | jq -r "[.[].id] | index(\"$SID\")"   # null (gone)
curl -s -H "$AUTH" "$BASE/api/v2/salons"       | jq -r "[.[].id] | index(\"$SID\")"   # null (app-facing gone)
curl -s -X POST -H "$AUTH" "$BASE/api/v2/admin/salons/$SID/restore" | jq .
curl -s -H "$AUTH" "$BASE/api/v2/admin/salons" | jq -r "[.[].id] | index(\"$SID\")"   # a number (back)
```

### [ ] Reset an owner's password → new works, old fails
```
NEWPW='ResetTest#2026'    # min 12
curl -s -X POST -H "$AUTH" -H 'Content-Type: application/json' \
  -d "{\"password\":\"$NEWPW\"}" "$BASE/api/v2/admin/users/$OWNER/reset-password" | jq .   # {ok:true}
# then confirm login as that owner (get their phone from the drill-down) with NEWPW → 200, old pw → 401
```

### [ ] Can't change your OWN role, can't delete your OWN account
```
curl -s -o /dev/null -w "%{http_code}\n" -X PATCH -H "$AUTH" -H 'Content-Type: application/json' \
  -d '{"role":"CUSTOMER"}' "$BASE/api/v2/admin/users/$ME/role"     # expect 400
curl -s -o /dev/null -w "%{http_code}\n" -X DELETE -H "$AUTH" "$BASE/api/v2/admin/users/$ME"   # expect 400
```

### [ ] Hard-delete a booking → gone (its BookingServiceItem rows cascade)
```
BID=$(curl -s -H "$AUTH" "$BASE/api/v2/admin/salons/$SID" | jq -r '.bookings[0].id')
curl -s -X DELETE -H "$AUTH" "$BASE/api/v2/admin/bookings/$BID" | jq .   # {ok:true}
curl -s -H "$AUTH" "$BASE/api/v2/admin/salons/$SID" | jq -r "[.bookings[].id] | index(\"$BID\")"  # null
```

### [ ] Malformed / oversized request → 4xx, not 500
```
curl -s -o /dev/null -w "%{http_code}\n" -X PATCH -H "$AUTH" \
  -H 'Content-Type: application/json' -d '{bad json' "$BASE/api/v2/admin/salons/$SID"   # expect 400
curl -s -o /dev/null -w "%{http_code}\n" -X PATCH -H "$AUTH" -H 'Content-Type: application/json' \
  -d '{"saasPlan":"NOPE"}' "$BASE/api/v2/admin/salons/$SID"    # expect 400 (unknown plan)
```

---

## 4. UI smoke test

1. Open `$BASE/admin`, sign in with the SUPER_ADMIN phone + password.
2. **Dashboard:** KPIs + chart + salon table load; click a salon → drill-down opens.
3. **Salon/owner/bookings:** edit + save (toast), typed-confirm delete works.
4. **Services / Staff / Customers:** inline edit + save; staff delete→restore; service delete; customer remove.
5. **Deleted tab:** shows what you soft-deleted, Restore works.
6. **Audit tab:** shows your recent actions, newest first.

---

## Result

Tick every box on pre-prod, then repeat on prod with a throwaway test salon. Once green, the console
is verified live — update [`ADMIN-CRUD-STATUS.md`](./ADMIN-CRUD-STATUS.md) §4 and STATUS.md item 3.
