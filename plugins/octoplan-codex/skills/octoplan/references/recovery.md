# Codex recovery

Read this for an ambiguous effect, failed actor, ownership conflict, material replan, legacy plan, or handoff. Recovery preserves the mandate; it never widens scope, invents authority, or stops an independent safe branch.

## Reconcile effects before retrying

Before an external non-idempotent effect that could duplicate or be hard to undo, add `OCTOPLAN_ACTION <stable-key>` to the owning task with the exact target, delivery-authorization source, intended effect, and pre-effect state. Use that key for one intent and at most one retry.

After a timeout or incomplete response, assume neither success nor failure. Inspect the authoritative target. If the effect is present, record its receipt. Retry only when authoritative evidence proves it absent, using the same key. If presence remains unknown, leave the action unresolved and block only descendants that need it. Never replay a whole batch to repair one uncertain item.

Use native idempotency and `expected_updated_at` on guarded Octopad updates. A conflict causes reread and reconciliation, never overwrite.

## Reconcile actors before replacement

Treat an actor as created only after its call returns or the authoritative native target confirms it. Before any retry or replacement, inspect that target. A successor must confirm that its predecessor stopped before acting; if that cannot be proved, pause only the affected branch. Never finish covertly under another identity.

## Bound recovery

- **Transient:** retry once with the same operation key.
- **Evidence gap:** refresh the authoritative source; never infer.
- **In scope:** try at most two distinct safe, reversible remedies.
- **Plan change:** stop affected work, update the Brief or Plan, and apply its fresh review and consent rules.
- **House rule or undisclosed event:** follow the contract in [SKILL.md](../SKILL.md).

Share one two-route verification-recovery budget across supervisor, workers, and reviewers. After two failed routes, preserve the strongest evidence and report the gap; attempt no third route and build no generic infrastructure for one-off proof. After two comparable cycles without a newly accepted artifact, review, or integrated proof, diagnose the Plan, context, task size, route, tool, and verifier before launching more work. Activity, drafts, tokens, and irrelevant checks are not progress.

## Change supervisor safely

Keep one supervisor at a time, named in a stream Decision. Before handoff, persist in-flight facts on their owning tasks. The successor confirms that the predecessor stopped, updates the Decision with its current `expected_updated_at`, then creates and records a new Goal before acting. A conflict pauses takeover for reread. The predecessor Goal remains historical: Goals never transfer, and an old Goal is complete only if its own objective was achieved. Existing delivery authorization carries across handoff unless authority or consequences changed.

## Replan without stale state

A wording fix or stable finding correction stays on the current Plan. A changed outcome, proof, boundary, assumption, task set or meaning, target, authority, route, verifier, deliverable, review trigger, disclosed effect, user checkpoint, or house-rule gate triggers the Brief or Plan path in supervision. Stop and reconcile an old worker before a replacement writes. Adopt a useful artifact only when the revised task names it and its evidence.

Do not execute a pre-v18 plan contract or private Octoplan control object. Treat it only as historical evidence: stop or reconcile actors and effects that may still be live; reread the current mandate, target rules, and Octopad graph; then create a freshly confirmed, reviewed, and authorized v18 Plan. Never transfer old PASS, authority, pending actions, supervisor ownership, or Goal state.

## Hand off durably

At an unrecovered incident or session handoff, persist exact in-flight facts on their owning tasks and use the six-field Delivery handoff. A successor resumes from Octopad, the delivery target, native task state, and the current supervisor Decision. Chat history is never the only copy of authority, progress, or an ambiguous effect.
