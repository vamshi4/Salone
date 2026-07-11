# Release to Marketing Workflow

This workflow makes sure every useful product release becomes a marketing opportunity.

## Goal

When Chairful ships a feature, marketing should automatically know:

- What changed
- Who it helps
- What pain it solves
- What screenshots or videos are needed
- What content should be created
- Whether the owner approved it
- Where it was posted

## Trigger Sources

The Feature Marketing Agent checks:

- `docs/STATUS.md`
- `docs/HANDOFF.md`
- `docs/DEPLOY-*.md`
- `docs/WALKIN-FLOW-DESIGN.md`
- Git commits since the last marketing pack
- Play Store release notes

Later, n8n can watch GitHub pushes, Play releases, and status doc updates.

## Workflow

1. Feature reaches one of these states:
   - Deployed to prod
   - Available in internal testing
   - Ready for closed testing
   - Ready for public launch

2. Feature Marketing Agent creates a campaign brief:
   - Feature name
   - Owner pain point
   - Benefit in plain words
   - Proof needed
   - Suggested content formats
   - Approval risk level

3. Social Media Agent creates content:
   - Instagram post
   - WhatsApp status
   - Facebook/LinkedIn post
   - Reel script
   - Salon-owner pitch message

4. Marketing Asset Guide creates asset prompts:
   - Screenshot list
   - Demo video storyboard
   - Image prompt
   - Short reel prompt

5. Content enters approval queue.

6. Owner approves, edits, or rejects.

7. n8n schedules/posts approved content.

8. Results are tracked:
   - Posted date
   - Platform
   - Views/clicks/replies
   - Lead quality
   - What to repeat

## Release Categories

### Tiny Release

Examples: text fix, UI polish, bug fix.

Marketing action:
- Maybe no public post.
- Add to weekly roundup if useful.

### Feature Release

Examples: walk-in logging, earnings, customer autocomplete.

Marketing action:
- Full feature campaign.
- 3-5 posts over 2 weeks.
- One demo video or reel.

### Trust Release

Examples: privacy, delete-account, security, admin console.

Marketing action:
- Use carefully.
- Focus on trust, reliability, and business safety.
- Avoid exposing internal security details.

### Launch Release

Examples: closed testing, public Play Store launch, pricing.

Marketing action:
- Launch campaign.
- Lead outreach.
- Founder story.
- Demo offer.

