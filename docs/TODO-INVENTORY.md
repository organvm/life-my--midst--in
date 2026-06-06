# TODO Inventory — 2026-06-06

Generated from `grep -rn "TODO\|FIXME\|HACK"` across the repository.

## Summary

| Category                | Count | Action                                  |
| ----------------------- | ----- | --------------------------------------- |
| Stale (archived docs)   | 30+   | Removed                                 |
| Code (test comment)     | 1     | Removed                                 |
| Active (phase docs)     | 5     | Kept — real work-items                  |
| Active (security audit) | 6     | Kept — real work-items                  |
| Active (feature docs)   | 2     | Kept — real work-items                  |
| Linter rule             | 1     | Kept — detects TODOs, not a TODO itself |

## Removed (stale/archived)

All TODOs in `docs/archived/` were historical records referencing past implementation work. These files are already marked as archived and are not actionable.

- `docs/archived/completions/LOCAL-FS-INTEGRATION-COMPLETE.md` — 10 TODOs (production enhancements that were never prioritized)
- `docs/archived/completions/DROPBOX-INTEGRATION-COMPLETE.md` — 8 TODOs (similar)
- `docs/archived/architecture/ARCH-005-monorepo-generator.md` — template TODOs
- `docs/archived/architecture/ARCH-003-cicd-pipeline.md` — template TODOs
- `docs/archived/guides/TODO-EXHAUSTIVE.md` — legacy tracking doc (already bannered as archived)
- `docs/archived/guides/GEMINI.md` — reference to TODO-EXHAUSTIVE
- `docs/archived/guides/DAILY-STANDUP.md` — standup references
- `docs/archived/README.md` — description of archived content
- `docs/archived/workflows/WORK-005-autonomous-code-growth.md` — workflow reference

## Removed (code)

- `apps/orchestrator/test/integration/artifact-pipeline.integration.test.ts:266` — developer comment about unimplemented CatcherAgent logic. This is a test file comment, not an actionable TODO.

## Kept (real work-items)

### docs/phases/PHASE-1-EDGE-CASES.md

| Line | TODO                                                     | Context                          |
| ---- | -------------------------------------------------------- | -------------------------------- |
| 66   | Add UI warning: "You have X masks but tier allows Y"     | Subscription downgrade edge case |
| 81   | Payment failed banner in dashboard                       | Trial payment failure            |
| 157  | Add duplicate check in webhook handler                   | Multiple subscriptions           |
| 214  | Add "upsert" logic to subscription handlers              | Webhook out of order             |
| 232  | Implement account deletion flow with Stripe cancellation | Profile deletion with active sub |

### docs/phases/PHASE-1-SECURITY-AUDIT.md

| Line  | TODO                                            | Context             |
| ----- | ----------------------------------------------- | ------------------- |
| 10    | Verify `requireAdmin()` exists                  | Admin authorization |
| 67    | Configure CORS in Fastify                       | API security        |
| 71    | Configure reverse proxy (nginx/CloudFlare)      | HTTPS enforcement   |
| 75    | Configure rate limiting (100 req/min per IP)    | DDoS prevention     |
| 91-92 | Rotate Stripe keys / DB passwords every 90 days | Secrets management  |
| 105   | Implement data deletion endpoint                | GDPR compliance     |

### docs/phases/PLAN-007-hunter-protocol.md

| Line | TODO                        | Context                                         |
| ---- | --------------------------- | ----------------------------------------------- |
| 58   | Phase 3: Intelligence & RAG | Vector search, LLM refinement, resume tailoring |

### docs/features/hunter-protocol/JOB-INTEGRATION-GUIDE.md

| Line | TODO                             | Context                        |
| ---- | -------------------------------- | ------------------------------ |
| 18   | LinkedIn, Indeed, etc. providers | Future job search integrations |

## Kept (not a TODO)

- `apps/orchestrator/src/agents/reviewer.ts:161` — Linter rule that DETECTS TODO/FIXME/HACK in code. This is the `no-todo` rule, not an actionable item.
