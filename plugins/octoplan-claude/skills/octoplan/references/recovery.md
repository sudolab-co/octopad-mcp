# Octoplan recovery

Read this for an ambiguous effect, failed actor, ownership conflict, material replan, legacy plan, or handoff. Recovery preserves the mandate; it never widens scope, invents authority, or stops an independent safe branch.

## Reconcile effects before retrying

Before an external non-idempotent effect that could duplicate or be hard to undo, add `OCTOPLAN_ACTION <stable-key>` to the owning task with the exact target, delivery-authorization source, intended effect, and pre-effect state. Use that key for one intent and at most one retry.

After a timeout or incomplete response, assume neither success nor failure. Inspect the authoritative target. If the effect is present, record its receipt. Retry only when authoritative evidence proves it absent, using the same key. If presence remains unknown, leave the action unresolved and block only descendants that need it. Never replay a whole batch to repair one uncertain item.

Use native idempotency and `expected_updated_at` on guarded Octopad updates. A conflict causes reread and reconciliation, never overwrite.

## Stop for shared-infrastructure distress

Shared-infrastructure timeouts, saturation, quota failure, or state contamination stop affected calls before ordinary retries. Record the system, event count, duration, and data magnitude; resume those calls only from a reviewed clean state. Continue safe diagnosis and independent work. No native continuation feature overrides this containment.

## Reconcile actors before replacement

Treat an actor as created only after its call returns or the authoritative native target confirms it. Before any retry or replacement, inspect that target. A successor must confirm that its predecessor stopped before acting; if that cannot be proved, pause only the affected branch. Never finish covertly under another identity.

## Diagnose before repeating

- **Transient:** retry once with the same operation key, only after proving the effect absent.
- **Evidence gap:** refresh the authoritative source; never infer success.
- **Execution defect:** return bounded fixes to the same healthy worker.
- **Plan defect:** ask a suitable planner to repair affected scope, review it, and resume with the owning supervisor.
- **New consequence or house rule:** follow [SKILL.md](../SKILL.md); stop only work needing that decision.

Two comparable cycles without accepted artifact, review, or integrated proof trigger diagnosis and a different defensible strategy before more dispatch. This internal trigger does not require another user go, reset a real attempt/spend limit, or allow endless trials. Preserve the strongest evidence. A failed worker, proof route, reviewer verdict, or run generation is not by itself a human decision. Exhausted compliant routes become a precise blocker only after the supervisor tests the underlying limitation and completes independent work. Build no generic infrastructure for one-off proof. Activity, drafts, tokens, and irrelevant checks are not progress.

## Change supervisor safely

Keep one supervisor per work boundary in stream Decisions. The current supervisor reaches a safe task boundary and persists in-flight facts, actors, effects, and evidence on their owning tasks. Stop or reconcile child workers before replacement; do not abandon uncertain effects. The runtime relay verifies the predecessor stopped, then launches a fresh successor with a bounded pointer to durable state. The successor rereads and updates ownership with the current `expected_updated_at`; a conflict requires reconciliation before acting. No full-history fork or concurrent takeover. Existing authorization carries across the handoff; native continuity ownership follows the selected runtime and is not transferred by a task comment. If no live relay is possible, disclose the manual fallback in [continuation.md](continuation.md).

## Replan without stale state

A wording fix or stable correction stays on the Plan. Classify material change with [planning.md](planning.md); it does not revoke consent unless [SKILL.md](../SKILL.md) says authority changed. Reuse the suitable planner or give a replacement only the missing judgment and current state; it does not take delivery ownership. For a user-mandate change, reconcile every affected open specification and artifact or actor left active, including native Goals, supervisor ownership, workers, pending actions, PRs, migrations, and effects. A superseded comment alone is not reconciliation. A rerun after a material premise change has a distinct task and premise; preserve old results and receipts. Never mark a native objective complete merely to replace it, and never resume a withdrawn mandate.

## Resume without a forced migration

Read the selected runtime's compatibility section. Valid existing Codex v18 and Claude mode-based plans retain their names, routes, authorizations, reviewed scope, and manual continuations. Do not demand new common fields or a new Brief solely because this skill's release version changed. Historical Claude Brief content may remain on its tracker; use that verified confirmation source without copying task status back into the tracker.

For an unknown, unsupported, or invalid contract, reconcile any live actors and effects first. Read the current user mandate, target rules, and graph. Preserve verifiable facts and authority that still applies, but never upgrade stale PASS or infer missing consent. Rebuild and review only the unproved scope; ask for an actually changed Brief or missing consequence decision. Unsupported pre-v18 Codex control objects are historical evidence, never an execution authority.

## Hand off durably

At an unrecovered incident or handoff, persist in-flight facts on owning tasks and use the six-field Delivery handoff. Before dispatch, the successor re-proves the decision served, premise, kill question, standing authority, pending effects, one supervisor, active actors, and person-waits; no new go is needed without an authority delta. Chat is never the only copy of authority, progress, or an ambiguous effect.
