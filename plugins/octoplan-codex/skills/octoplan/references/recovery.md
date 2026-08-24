# Codex recovery

Read this for an ambiguous effect, failed actor, ownership conflict, material replan, legacy plan, or handoff. Recovery preserves the mandate; it never widens scope, invents authority, or stops an independent safe branch.

## Reconcile effects before retrying

Before any external effect that could duplicate or be hard to undo, add `OCTOPLAN_ACTION <stable-key>` to the owning task with the exact target, delivery-authorization source, intended effect, and pre-effect state. Use that key for one intent and for at most one retry of the same intent.

After a timeout or incomplete response, assume neither success nor failure. Inspect the authoritative target. If the effect is present, record its exact receipt. Retry only when authoritative evidence proves it absent, using the same operation key. If presence remains unknown, leave the action unresolved and block only descendants that need it. Never replay a whole batch to repair one uncertain item.

Use native idempotency and `expected_updated_at` on guarded Octopad updates. A conflict causes reread and reconciliation, never overwrite.

## Reconcile dispatch before replacement

Before spawning, record `OCTOPLAN_DISPATCH <stable-key>` on the owning task with role, Octopad task ID, intended native target or worktree, exact route, and authority source. Create once. Record the returned native identity, observed route, target association, and Octopad binding before reporting creation or allowing work.

An ambiguous create pauses that branch while native task reads reconcile it. Do not create again because a field or response is missing. A worker that errors, disappears, or returns unverifiable work gets one fresh retry on the same Octopad task only after native evidence proves the predecessor stopped, its dispatch is terminal, and authoritative targets prove its effects quiescent. The replacement gets a new dispatch key. If it also fails, stop that branch; never finish covertly under another identity.

## Bound recovery

Classify only enough to choose the next move:

- **Transient:** retry once with the same operation key.
- **Evidence gap:** refresh the authoritative source; never infer.
- **In scope:** try at most two distinct safe, reversible remedies.
- **Plan change:** stop affected work, update the Brief or Plan, and apply its fresh review and consent rules.
- **House rule or undisclosed event:** open the recorded gate or request new consequence consent.

Share one two-route verification-recovery budget across supervisor, workers, and reviewers. After two failed routes, preserve the strongest evidence and report the gap; attempt no third route and build no generic infrastructure for one-off proof. After two comparable work or review cycles without a newly accepted artifact, review, or integrated proof, diagnose the Plan, context, task size, route, tool, and verifier before launching more work. Activity, drafts, tokens, and irrelevant checks are not progress.

## Rotate supervisor ownership safely

Only the native task and Goal named by the current `Octoplan 18 supervisor lease` may supervise. Before takeover, stop at a safe boundary. Write in-flight state, artifact versions, verification output, dispatch state, ambiguous effects, and next ready work on their owning tasks. Record a quiescence receipt.

Update the lease with its current `expected_updated_at`, the successor native-task identity, incremented generation, `goal identity: null`, and the quiescence evidence. The predecessor is fenced immediately and may perform no later effect if it wakes. A conflict pauses takeover for reread.

The successor verifies the predecessor is terminal or unreachable, the guarded lease rotation, and post-fence effect quiescence. It then creates a new Goal and records its identity. The predecessor Goal remains historical. Goals never transfer, and an old Goal is never marked complete unless its own objective was achieved. Exact delivery authorization carries across takeover; changed authority or consequence does not.

## Replan without stale state

A wording fix or stable finding correction stays on the current Plan. A changed outcome, proof, boundary, assumption, stream/task graph or membership, task meaning, target, authority, route, verifier, deliverable, review trigger, disclosed effect, user checkpoint, or house-rule gate triggers the Brief or Plan path in supervision. Stop and reconcile an old worker before a replacement writes. Adopt a useful artifact only when the revised task names it and its evidence.

Do not execute any pre-v18 plan contract or private Octoplan control object. Treat it only as historical evidence: stop or reconcile every actor and effect that may still be live; reread the current mandate, target rules, and real Octopad graph; then create a freshly confirmed, reviewed, and authorized v18 Plan. Never transfer an old PASS, authority claim, pending action, supervisor ownership, lease generation, or Goal state.

## Hand off durably

At an unrecovered incident or session handoff, persist the exact in-flight facts on their owning tasks and use the six-field Delivery handoff. A successor resumes from Octopad, the delivery target, native task state, and the lease. Chat history is never the only copy of authority, progress, or an ambiguous effect.
