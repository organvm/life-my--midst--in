# Agent Handoff: Addressing Technical Debt, Issues, and PRs

**From:** Session a2094a53 | **Date:** 2026-06-06 | **Phase:** BUILD (Finalized)

## Current State

- Build/test fixes landed and active TODO inventory was documented.
- 2026-06-07 review correction: `scripts/secrets.env.op.sh` now clears stale token variables, never attempts interactive `op signin` during directory load, validates candidate 1Password GitHub tokens before export, and falls back to GitHub CLI keyring auth when 1Password is not signed in. The matching `GitHub-Tokens` vault records were refreshed from the valid keyring token and validate as user `4444J99`.
- Changes committed on branch `worktree-2026-06-06-14-42-57-468-ss1k`.
- Repository: `a-organvm/life-my--midst--in`

## Completed Work

- [x] **Merged PR #125**: dependency bumps (vite, next, opentelemetry).
- [x] **Merged PR #126**: academic domain implementation.
- [x] **Fixed TS6059**: Cleared inherited `paths` in `packages/core/tsconfig.json` and `packages/content-model/tsconfig.json`.
- [x] **Resolved TODOs**:
  - Added masks table indexes in `apps/api/migrations/009b_performance_indexes.sql`.
  - Configured `google` provider in `infra/terraform/main.tf`.
  - Cleaned implementer agent stub in `apps/orchestrator/src/agents/implementer.ts`.
- [x] **1Password Hydration Refactor**: Refactored `scripts/secrets.env.op.sh` to use IDs/Vaults instead of titles to handle colons (`:`) and duplicates.
- [x] **Stale Token Guard**: `scripts/secrets.env.op.sh` unsets token variables before attempting 1Password hydration so locked/failed hydration does not leave an invalid `GITHUB_TOKEN` active.
- [x] **Non-Interactive Secret Loading**: Removed directory-load `op signin` attempts; sign in manually before `direnv reload` when vault-backed secrets are required.
- [x] **Token Validation**: The loader skips invalid 1Password token candidates and exports only a token that passes `gh api user`.
- [x] **1Password Token Refresh**: Refreshed the matching `GitHub-Tokens` vault credentials from the valid GitHub CLI keyring token and verified they authenticate as `4444J99`.

## Key Decisions

| Decision                                  | Rationale                                                                                          |
| ----------------------------------------- | -------------------------------------------------------------------------------------------------- |
| ID-based retrieval for 1Password          | Titles with colons break the `op://` URI syntax; specific IDs also handle duplicate titles safely. |
| Clearing `paths` in sub-package tsconfigs | Inherited root `paths` were causing `rootDir` errors (`TS6059`) during individual package builds.  |

## Critical Context

- `direnv` is non-interactive. It **requires** a pre-existing 1Password session (`eval $(op signin)`) to load secrets via `scripts/secrets.env.op.sh`.
- PR #126 introduced 26 new tests; all passed during verification.

## Next Actions

1. **Validation**: Re-run `pnpm typecheck`, `pnpm test`, `pnpm lint`, `pnpm build`, and `git diff --check` after any cleanup.
2. **Environment**: When vault-backed secrets are needed, run `eval $(op signin)` manually before `direnv reload`; otherwise GitHub CLI falls back to keyring auth with token variables unset.
3. **Push**: If authorized, push the current branch or merge into main after validation and credential checks.

## Risks & Warnings

- Ensure your local `op` CLI is signed into the account containing the `GitHub-Tokens` vault before expecting direnv to export vault-backed tokens.
- Directory load is intentionally non-interactive; it must not prompt or fan out repeated 1Password sign-in attempts.

## TODO Cleanup (2026-06-06)

### Actions Taken

- **Removed 30+ stale TODOs** from `docs/archived/` (historical records, not actionable)
- **Removed 1 code TODO** from `apps/orchestrator/test/integration/artifact-pipeline.integration.test.ts` (developer comment about unimplemented logic)
- **Kept 14 active TODOs** in phase/feature docs (real work-items)
- **Kept 1 linter rule** in `reviewer.ts:161` (detects TODOs, not a TODO itself)

### Inventory

See `docs/TODO-INVENTORY.md` for full breakdown of all markers by file, line, and action taken.

### Remaining Active TODOs

| File                                                     | Count | Category                        |
| -------------------------------------------------------- | ----- | ------------------------------- |
| `docs/phases/PHASE-1-EDGE-CASES.md`                      | 5     | Payment/subscription edge cases |
| `docs/phases/PHASE-1-SECURITY-AUDIT.md`                  | 6     | Security hardening              |
| `docs/phases/PLAN-007-hunter-protocol.md`                | 1     | Intelligence/RAG phase          |
| `docs/features/hunter-protocol/JOB-INTEGRATION-GUIDE.md` | 1     | Future job providers            |
