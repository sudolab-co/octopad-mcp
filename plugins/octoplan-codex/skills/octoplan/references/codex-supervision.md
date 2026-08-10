# Codex supervision

Read this reference after valid launch authority or when resuming. Octopad holds the approved plan and recovery state; native Codex provides working-session evidence.

## Contents

- [Run and ownership](#run-and-ownership)
- [Supervisor loop](#supervisor-loop)
- [Native actors](#native-actors)
- [Execution and review](#execution-and-review)
- [Incidents and replanning](#incidents-and-replanning)
- [Human gates](#human-gates)
- [Resume and close](#resume-and-close)

## Run and ownership

Before a claim, write, message, archive, PASS, or native create, verify one `octoplan-plan-v2`, its approved revision, status, identity, dedicated supervisor owner/epoch, execution authority, covering action grant, budgets, and relevant gate. A mismatch causes targeted reconciliation, not inferred repair.

Use `approved`, `active`, `replanning`, `waiting-human`, `paused`, `completed`, and `superseded`. Review verdicts are evidence, not run states. Every state or owner change uses the coordination task's `expected_updated_at`; a failed guard causes a reread and authorizes nothing.

Exactly one dedicated native supervisor epoch owns advancement; supervision is never inline. Use title `Supervisor - <short-plan> - <mission>` within 64 characters, keep it and the planner visible, and default to compact delta-first Terra `high`. Raise route only for evidenced ambiguity. Never create a reporting-only parent.

## Supervisor loop

At every wake:

1. refresh the coordination task, pending operation keys, open gates, current task statuses, and relevant native sessions;
2. reconcile pending writes and actor intents before issuing new ones;
3. rank the critical path and derive `eligible_safe_ready` from dependencies, gates, conflicts, routes, capabilities, and budgets;
4. launch up to bounded capacity, then backfill from the remaining safe frontier after reconciliation;
5. collect artifacts and run the saved review class;
6. record accepted receipts, review outcomes, completion, incidents, and the next wake;
7. continue independent safe work until a real pause condition remains.

Use Octopad's graph/statuses directly; do not mirror a scheduler. Exclude candidates conflicting in files, symbols, artifacts, migrations, lockfiles, scarce resources, gates, routes, or budgets. Repetitive independent items use bounded partial batches with individual artifacts, receipts, and verdicts. Never require all-ready activation: fill available WIP, reconcile, then backfill.

Apply the SKILL user-visible identifier rule to recaps. Internal prompts, ledger records, arguments, and creation records retain the full correlation identifiers.

## Native actors

Only the current supervisor claims tasks, creates/messages/archives actors, starts reviewers, validates authority/gates, records accepted outcomes, and advances the graph. Executors may relay a received answer to it but never validate advancement, change route, or launch.

Before creation, append the intent from [state-and-recovery.md](state-and-recovery.md). Use `Supervisor - <short-plan> - <mission>`, `Executor E01 - <short-plan> - <short-task>`, `Reviewer - <short-plan> - <short-task>`, or `Planner - <short-plan> - <purpose>`, capped at 64 characters without opaque IDs.

The first prompt carries the stable creation key and complete role packet. Call create once. `clientThreadId`, empty output, timeout, or crash enters bounded reconciliation. Reconcile native list/read by the creation key and project. One exact material match becomes ready; several or a wrong project pauses. After one setup window and a second zero-match read, pause that branch as `creation-dispatch-ambiguous` with the wake predicate defined in the state reference. Never retry create to improve a response.

Only an actor with the current supervisor epoch may activate. On takeover, prove the prior owner fenced, increment the epoch under `expected_updated_at`, then reconcile existing actors before replacement.

Use targeted reconciliation: refresh pending keys, attempts, lifecycle, artifacts, reviews, gates, and changed sources. A native session is evidence, not completion. Titles/prose never substitute for identity, authority, status, or receipt.

Actor lifecycle is `active -> awaiting-review -> correction-needed | handoff-pending -> terminal-reconciled -> archived`. Terminal requires report, acknowledged ownership transfer, and reconciliation. Reuse a healthy executor for correction before creating another. Archive reversibly only after PASS, abandonment, or supersession, no correction/recheck/human/handoff wait, and a transfer receipt. Keep planner, supervisor, and user/handoff waiters visible. Persist archive receipts; an archive incident stays pending/reconciled but never blocks delivery.

## Execution and review

Each executor verifies key, plan/revision, epoch, project, task ref, route, and lifecycle, then enters Octopad and reads the live self-contained task. It owns the mission interaction point; a human task never becomes agent work through fallback.

Run deterministic checks first. On return, the supervisor checks artifact revision and saved review class. `targeted` inspects the actual diff/artifact and named checks. `independent` is fresh source-first for product, code, security, privacy, data, migration, or public work; `specialist` adds only a second orthogonal material domain. Integrated multi-component candidates require integrated review.

Accept only explicit verdicts with executed evidence. Silence, timeout, missing checks, or another revision is not PASS. Return stable finding keys to the healthy executor for correction, then targeted-recheck changed artifact and affected criteria. After two `REVISE` with the same key, forbid a blind third loop: diagnose plan/tool/verifier/route and repair or replan. Preserve unrelated PASS. Only the supervisor records accepted PASS or advancement.

At artifact completion (`awaiting-review`), human/handoff wait, or an incident unresolved after bounded recovery, the executor publishes exactly `État`, `Fait`, `Bloqué`, `Décision attendue`, `Pour débloquer`, and `Prochaine étape`; `Aucune` or `Sans objet` is valid. It may receive and transfer a reply. This report is not authority or durable gate evidence until supervisor validation.

## Incidents and replanning

A missing tool, skill, context item, capability, environment, source, or verifier is an incident owned by the supervisor, not automatically a user blocker. Preserve safe independent work, diagnose the failed predicate, restore capability or choose a safe workaround inside the approved envelope, and use one bounded planner/recovery actor when useful. That actor proposes; it cannot claim, launch, persist, or ask the user.

Treat a change as a repair when result, scope, risk, acceptance, route bounds, and protected gates remain unchanged. Record the comparison, execute the smallest correction, review the affected surface, and resume. A non-blocking follow-up gets a stable reason and deduplication key but is not a reporting-only actor in the run.

If task meaning, graph, route bound, authority, protected gate, or acceptance changes, set `replanning`, stop new affected claims, and increment the proposed revision. Let demonstrably independent claimed work finish or fence it. Build a concrete delta and artifact adoption map, run proportionate independent plan review, persist and verify the new essential IDs/edges, then approve the next revision. No old plan-review or affected task PASS transfers.

Contact the user only for a true material choice, missing real authority, unreconcilable identity/duplicate, a protected gate, or evidence that no compliant route remains. Record a stable blocker key so rewording or actor replacement does not reset the diagnosis.

## Human gates

Secrets, access grants, spend, destructive effects, human review, merge, migration application, deployment, publication, and acceptance stay protected occurrences. Human review and merge are embedded in the owning E delivery task, not separate Octopad tasks; other kinds may use an Hxx human task. A PR is linked to that same Octopad delivery task under the active workflow; after merge, reconcile its auto-close/completion comment and closure evidence instead of creating a review or merge task. Delivery mode and plan approval never complete gates.

A gate blocks only its dependent branch. Continue independent safe work. When no safe frontier remains, update state to `waiting-human` or `paused` under the concurrency guard and publish exactly:

- `État`
- `Fait`
- `Bloqué`
- `Décision attendue`
- `Pour débloquer`
- `Prochaine étape`

Record the handoff receipt idempotently. A rejection preserves the artifact and evidence, reopens the same delivery task through a repair or replan, and returns to the same human gate without duplicating it. An external wake supplies evidence only; verify its exact target/revision before resuming.

## Resume and close

On resume, follow [state-and-recovery.md](state-and-recovery.md): refresh live Octopad and native state, reconcile pending operation keys and creation intents, then wake the unique resumable supervisor. Replace it only when native evidence proves it terminal or unreachable and the guarded epoch rotation succeeds. Absence of observation is not proof.

A dead executor is fenced before a new attempt. If no artifact exists, restart from the saved task; if one exists, adopt or reject it explicitly and review the chosen revision. A predecessor PASS never transfers to a changed artifact.

The supervisor writes `completed` only after current global integrated-outcome evidence, required task/review evidence, every gate is `satisfied` with evidence, final validation, empty pending operations, and every actor is terminal-reconciled or archived. Component or branch completion is insufficient. `waiting-human` and `paused` end a pass but are never terminal success.

The final six-field recap reports artifacts, checks, reviews, human work, repairs, blockers, follow-ups, risks, and actual session/event counts. Include observed tokens, tool calls, compactions, and retries when available; otherwise say unavailable, without estimation. Use returned links and human references, not opaque IDs.

Pause the affected branch only for the strict conditions in the state reference. Stop the whole plan only when shared identity/authority is invalid or no safe agent-owned frontier remains.
