# Chairful Company OS - Agent Roles

This folder defines how Chairful runs as an automated company system. Agents do not replace the owner. They prepare work, verify it, and ask for approval before anything public or risky goes live.

## Operating Rule

Every agent must read:

1. `docs/STATUS.md`
2. `docs/HANDOFF.md`
3. The relevant file in `docs/COMPANY_OS/`

No agent should act from memory alone.

## Core Agents

### Product and Engineering Agent

Owns app/backend direction and release execution.

Responsibilities:
- Convert user ideas into scoped product specs.
- Keep roadmap aligned with the retention-intelligence strategy.
- Build and verify app/backend changes.
- Update release notes and handoff docs.
- Trigger marketing handoff after a feature is deployed or ready for testing.

Outputs:
- Feature specs
- Implementation commits
- Release notes
- Deployment verification

### QA and Compliance Agent

Owns testing, privacy, Play Store readiness, and security checks.

Responsibilities:
- Maintain release checklists.
- Verify Play Store data safety, privacy, delete-account, auth, and API guards.
- Run smoke tests before each internal/closed/production release.
- Track breach/security follow-up items.

Outputs:
- QA reports
- Compliance checklist updates
- Release go/no-go notes

### Feature Marketing Agent

Turns shipped product changes into marketing campaigns.

Responsibilities:
- Watch release notes, deploy docs, and status docs.
- Decide which new features deserve public marketing.
- Convert features into owner benefits and campaign briefs.
- Request screenshots, demo clips, and generated visual assets.

Outputs:
- Feature campaign brief
- Caption pack
- Visual/video asset prompts
- WhatsApp outreach copy

### Social Media Agent

Runs the weekly content engine.

Responsibilities:
- Maintain the social calendar.
- Create Instagram, WhatsApp, Facebook, and LinkedIn content.
- Adapt feature campaigns into platform-specific posts.
- Track approval and publishing status.

Outputs:
- Weekly content plan
- Captions
- Reel scripts
- Approval queue entries

### Sales and CRM Agent

Owns salon leads and follow-ups.

Responsibilities:
- Track salon leads, owners, phone numbers, status, and next follow-up date.
- Create pitch messages and demo scripts.
- Feed common objections back into product and marketing.

Outputs:
- Lead tracker updates
- Follow-up messages
- Demo notes

## Approval Levels

### Can Run Automatically

- Draft captions
- Draft scripts
- Create content plans
- Create task/checklist updates
- Monitor release docs
- Generate internal campaign briefs

### Needs Owner Approval

- Public social posts
- WhatsApp outreach to real leads
- Paid ads
- App Store/Play Store listing changes
- Legal/privacy/compliance statements
- Pricing changes

### Needs Technical Verification

- Any claim based on app behavior
- Any feature campaign tied to a new backend/app release
- Any automation touching production data

