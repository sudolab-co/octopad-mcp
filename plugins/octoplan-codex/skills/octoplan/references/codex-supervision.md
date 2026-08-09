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

Before a claim, write, message, PASS, or native create, verify one `octoplan-plan-v1`, its approved revision, current status, organization/workspace/stream, supervisor owner/epoch, execution authority, creation grant, and relevant gate. A mismatch causes targeted reconciliation, not inferred repair.

Use `approved`, `active`, `replanning`, `waiting-human`, `paused`, `completed`, and `superseded`. Review verdicts are evidence, not run states. Every state or owner change uses the coordination task's `expected_updated_at`; a failed guard causes a reread and authorizes nothing.

Exactly one supervisor epoch owns advancement. Inline supervision is preferred. Create a dedicated supervisor only when several remaining tasks, meaningful parallel work, multiple streams, or long waits justify durable separation. Never create a reporting-only parent.

## Supervisor loop

At every wake:

1. refresh the coordination task, pending operation keys, open gates, current task statuses, and relevant native sessions;
2. reconcile pending writes and actor intents before issuing new ones;
3. identify every ready, safe, agent-owned frontier from live dependencies;
4. claim and launch only tasks covered by the approved revision, route, project, and authority;
5. collect artifacts and run the saved review class;
6. record accepted receipts, review outcomes, completion, incidents, and the next wake;
7. continue independent safe work until a real pause condition remains.

Use Octopad's task graph and statuses directly; do not maintain a second complete scheduler. Before parallel launch, prove members have no conflicting files, symbols, artifacts, migrations, lockfiles, scarce resources, or gates. If all-ready activation is unavailable, serialize; do not create a partial parallel group.

Apply the SKILL user-visible identifier rule to recaps. Internal prompts, ledger records, arguments, and creation records retain the full correlation identifiers.

## Native actors

Only the current supervisor claims tasks, creates actors, starts reviewers, records accepted outcomes, and advances the graph. Executors and reviewers return evidence to it; they never relay or launch.

Before creation, append the one intent defined in [state-and-recovery.md](state-and-recovery.md). Use a readable title such as `Supervisor - <short-plan>`, `Executor E01 - <short-plan> - <short-task>`, `Reviewer - <short-plan> - <short-task>`, or `Planner - <short-plan> - <purpose>`, capped at 64 characters and containing no opaque IDs.

The first prompt carries the stable creation key and complete role packet. Call create once. `clientThreadId`, empty output, timeout, or crash enters bounded reconciliation. Reconcile native list/read by the creation key and project. One exact material match becomes ready; several or a wrong project pauses. After one setup window and a second zero-match read, pause that branch as `creation-dispatch-ambiguous` with the wake predicate defined in the state reference. Never retry create to improve a response.

Only an actor with the current supervisor epoch may activate. On takeover, prove the prior owner fenced, increment the epoch under `expected_updated_at`, then reconcile existing actors before replacement.

Use targeted reconciliation: refresh only pending operation keys, active attempts, artifact revisions, reviews, gates, and changed sources. A native session is evidence of work, not durable task completion. Display titles and response prose never substitute for plan identity, authority, project, task status, or a receipt.

## Execution and review

Each executor first verifies its creation key, plan ID/revision, supervisor epoch, project, task ID/ref, route, and active status, then enters the exact Octopad workspace and reads the full live task. It produces only the saved artifact and evidence; a human task never becomes agent work through fallback.

On return, the supervisor checks the artifact revision and runs the task's saved review class. `targeted` must inspect the actual diff or artifact and execute the named checks. `independent` and `specialist` use fresh source-first actors. All compare against **Done when**, boundaries, source revisions, and protected gates.

Accept only explicit verdicts with executed evidence. Silence, timeout, missing checks, or review of another artifact revision is not PASS. A `REVISE` returns bounded findings to a correction actor; then recheck those findings and affected criteria. Preserve unrelated PASS evidence. The supervisor alone records accepted PASS and task completion.

## Incidents and replanning

A missing tool, skill, context item, capability, environment, source, or verifier is an incident owned by the supervisor, not automatically a user blocker. Preserve safe independent work, diagnose the failed predicate, restore capability or choose a safe workaround inside the approved envelope, and use one bounded planner/recovery actor when useful. That actor proposes; it cannot claim, launch, persist, or ask the user.

Treat a change as a repair when result, scope, risk, acceptance, route bounds, and protected gates remain unchanged. Record the comparison, execute the smallest correction, review the affected surface, and resume. A non-blocking follow-up gets a stable reason and deduplication key but is not a reporting-only actor in the run.

If task meaning, graph, route bound, authority, protected gate, or acceptance changes, set `replanning`, stop new affected claims, and increment the proposed revision. Let demonstrably independent claimed work finish or fence it. Build a concrete delta and artifact adoption map, run proportionate independent plan review, persist and verify the new essential IDs/edges, then approve the next revision. No old plan-review or affected task PASS transfers.

Contact the user only for a true material choice, missing real authority, unreconcilable identity/duplicate, a protected gate, or evidence that no compliant route remains. Record a stable blocker key so rewording or actor replacement does not reset the diagnosis.

## Human gates

Secrets, access grants, spend, destructive effects, merge, migration application, deployment, publication, and acceptance stay as separate human tasks. Delivery mode and plan approval never complete them.

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

The supervisor closes only after every required delivery task has current review evidence, every desired dependency and protected gate is resolved, final validation ran, pending operations are empty, and known risks/follow-ups are recorded. Write `completed` under `expected_updated_at`.

The final six-field recap reports delivered artifacts, executed checks, review results, human work, repairs, blockers, follow-ups, risks, and actual session/event counts using returned links and human references rather than opaque IDs.

Pause the affected branch only for the strict conditions in the state reference. Stop the whole plan only when shared identity/authority is invalid or no safe agent-owned frontier remains.
