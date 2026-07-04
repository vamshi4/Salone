# Production Readiness

Salone is not production-ready until every P0 and P1 item below is complete and tested on a deployed environment.

## P0 - Must Finish Before Real Users

- Real authentication:
  - Customer login.
  - Stylist login.
  - Salon admin login.
  - Role-based access checks on every write endpoint. `AUTH_REQUIRED=true` enables enforcement.
- Replace demo identities:
  - Remove hard-coded `customer-demo`.
  - Remove app-side selection of the first/Ravi stylist.
- Secrets and environment:
  - Set strong `JWT_SECRET`.
  - Use production `DATABASE_URL`.
  - Set explicit `CORS_ORIGIN`.
  - Do not expose Prisma Studio or database ports publicly.
- Database migrations:
  - Use versioned Prisma migrations.
  - Do not use `prisma db push --accept-data-loss` in production.
- Booking correctness:
  - End-to-end tests for create, confirm, reject, reschedule accept, reschedule reject, availability blocks, and conflict prevention.
- Payments:
  - Payment intent/order creation.
  - Payment confirmation webhook.
  - Refund/no-show flow.
  - Commission and payout audit trail.

## P1 - Needed For Launch Quality

- Push notifications for booking confirm/reject/reschedule.
- Audit logs for admin and provider actions.
- Rate limiting on public APIs.
- Structured logging and error tracking.
- Backup and restore plan for Postgres.
- App signing and release builds for all Android apps.
- Privacy policy, terms, and data deletion workflow.

## P2 - Product Maturity

- Reviews and flagging workflow.
- Calendar-style availability editing.
- Search/filter implementation beyond visual chips.
- Real customer/stylist/salon onboarding.
- Admin reporting and exports.

## Current Hardening Added

- Backend CORS can be restricted with `CORS_ORIGIN`.
- Backend JSON body size is limited with `JSON_LIMIT`.
- Backend has signed bearer-token helpers and role middleware.
- Backend write endpoints are wrapped in role checks.
- Development can issue a demo token from `/api/v2/auth/demo-token` while `DEMO_AUTH_ENABLED=true`.
- Backend returns generic errors for unhandled server errors.
- Backend disconnects Prisma on shutdown.

## Current Demo Limitations

- Apps still use demo/local identity assumptions.
- Apps do not yet have login screens or token storage.
- Production auth enforcement requires `AUTH_REQUIRED=true`.
- Notifications are in-app only.
- Payments are not implemented.
- Local Docker compose is for development, not production deployment.
