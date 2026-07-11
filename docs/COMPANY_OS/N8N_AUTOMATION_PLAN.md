# n8n Automation Plan

n8n is the automation engine for Chairful. It should move information between systems and trigger agents, but it should not publish risky content without approval.

## Phase 1 - Manual Approval Automation

Goal: automate preparation, not public posting.

Workflows:

1. Watch GitHub/status docs for release updates.
2. Create a Feature Marketing Agent task.
3. Generate campaign draft and add it to `CONTENT_APPROVAL_QUEUE.md`.
4. Notify owner for approval.

## Phase 2 - Social Scheduling

Goal: approved content gets scheduled automatically.

Workflows:

1. Owner approves content.
2. n8n sends approved caption/assets to scheduler.
3. Post status changes to Scheduled.
4. After posting, n8n writes the posted link/result back.

## Phase 3 - CRM and Follow-Up

Goal: connect marketing to salon leads.

Workflows:

1. New lead form submission -> CRM row.
2. Lead status change -> follow-up task.
3. No reply after 2 days -> draft WhatsApp follow-up.
4. Demo completed -> ask for next action.

## Phase 4 - Monitoring

Goal: protect launches and campaigns.

Workflows:

1. API health check every 5 minutes.
2. Play/internal release status reminder.
3. Failed API or bad release state -> owner alert.
4. Weekly report of leads, posts, and app status.

## Approval Gates

n8n can automatically:

- Create tasks
- Draft content
- Update docs
- Notify owner
- Schedule approved content

n8n must not automatically:

- Publish unapproved posts
- Message real leads without approval
- Change pricing
- Change Play Store declarations
- Touch production data directly

