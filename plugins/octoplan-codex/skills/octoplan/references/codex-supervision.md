# Codex supervision

Read this reference after valid launch authority or when resuming. Octopad holds the approved plan and recovery state; native Codex provides working-session evidence.

## Contents

- [Run and ownership](#run-and-ownership)
- [Supervisor loop](#supervisor-loop)
- [Native actors](#native-actors)
- [Execution and review](#execution-and-review)
- [Incidents and replanning](#incidents-and-replanning)
- [Human checkpoints and Goal state](#human-checkpoints-and-goal-state)
- [Resume and close](#resume-and-close)

## Run and ownership

Before a claim, write, message, archive, PASS, or native create, verify one `octoplan-plan-v3`, its plan and intent revisions, status, identity, compatible runtime version, current supervisor/Goal owner and epoch, execution authority, budgets, and relevant checkpoint. A mismatch causes targeted reconciliation, not inferred repair.

Use `planning`, `planned`, `active`, `replanning`, `waiting-human`, `paused`, `completed`, and `superseded`. Review verdicts are evidence, not run states. Every state, intent, or owner change uses the coordination task's `expected_updated_at`; a failed guard causes a reread and authorizes nothing.

Exactly one supervisor epoch owns advancement. The current user task is that supervisor by default and its native Goal supplies persistence across turns. A separate supervisor is chosen and fenced before Goal creation when an unrelated Goal or evidenced environment isolation requires it. Once an unfinished Goal exists, never claim to transfer or fence it through an unsupported primitive, and never falsely complete/block it to enable handoff. Never create a reporting-only parent or two competing Goals/heartbeats.

## Supervisor loop

At every wake:

1. refresh the coordination task, native Goal, installed skill version, latest intent, pending operation keys, open checkpoints, current task statuses, and relevant native sessions;
2. reconcile pending writes and actor intents before issuing new ones;
3. rank the critical path and derive `eligible_safe_ready` from dependencies, checkpoints, conflicts, routes, capabilities, and budgets;
4. launch up to bounded capacity, then backfill from the remaining safe frontier after reconciliation;
5. collect artifacts and run the saved review class;
6. record accepted receipts, review outcomes, completion, incidents, and any timed external wake;
7. continue independent safe work until a real pause condition remains.

Use Octopad's graph/statuses directly; do not mirror a scheduler. Exclude candidates conflicting in files, symbols, artifacts, migrations, lockfiles, scarce resources, checkpoints, routes, or budgets. Repetitive independent items use bounded partial batches with individual artifacts, receipts, and verdicts. Never require all-ready activation: fill available WIP, reconcile, then backfill.

At every actor safe boundary, reread `intent.revision` before the next external effect. A natural-language pause, cancellation, reprioritization, replacement, diagnostic limit, or “do not send” becomes durable state first; only then message affected actors. Stale actors stop or finish only the explicitly safe boundary recorded by the new intent. Do not rely on conversation memory or a user-facing command grammar.

Follow active native tasks with compact cursor-based `wait_threads`; a task's commentary or silence is not plan state. Create at most one heartbeat per plan, and only for a timed external predicate such as CI, human merge, or deployment evidence when native waiting cannot persist the wake. Its prompt must refresh the coordination task and current intent/checkpoint before acting, never embed a copied blocker. Update or delete it when intent or predicate changes, and remove it on completion. Never heartbeat active Codex actors or use one as a second supervisor.

Apply the SKILL user-visible identifier rule to recaps. Internal prompts, ledger records, arguments, and creation records retain the full correlation identifiers.

## Native actors

Only the current supervisor claims tasks, creates/messages/archives actors, starts reviewers, validates authority/checkpoints, records accepted outcomes, and advances the graph. Executors may relay a received answer to it but never validate advancement, change route, or launch.

Before creation, append the intent from [state-and-recovery.md](state-and-recovery.md). Use `Supervisor - <short-plan> - <mission>`, `Executor E01 - <short-plan> - <short-task>`, `Reviewer - <short-plan> - <short-task>`, or `Planner - <short-plan> - <purpose>`, capped at 64 characters without opaque IDs.

Every native child's first prompt explicitly says `Use $octoplan as <role>` and names the matching `roles/<role>.md` pack, then carries the stable creation key and complete role packet, including schema and minimum Octoplan version. Call create once. `clientThreadId`, empty output, timeout, crash, or incomplete project metadata such as `projectId=null` enters bounded reconciliation. Reconcile native list/read by the creation key and the runtime evidence hierarchy. One exact material match becomes ready; several candidates or a proven wrong project pauses. After one setup window and a second zero-match read, pause that branch as `creation-dispatch-ambiguous` with the wake predicate defined in the state reference. Never retry create to improve a response or escape ambiguous metadata.

Only an actor with the current supervisor epoch may activate. On takeover, prove the prior owner fenced, increment the epoch under `expected_updated_at`, then reconcile existing actors before replacement.

Use targeted reconciliation: refresh pending keys, attempts, lifecycle, artifacts, reviews, checkpoints, intent, runtime version, and changed sources. A native session is evidence, not completion. Titles/prose never substitute for identity, authority, status, or receipt.

Actor lifecycle is `active -> awaiting-review -> correction-needed | handoff-pending -> terminal-reconciled -> archived`. Terminal requires report, acknowledged ownership transfer, and reconciliation. Reuse a healthy executor for correction before creating another. Archive reversibly only after PASS, abandonment, or supersession, no correction/recheck/human/handoff wait, and a transfer receipt. Keep planner, supervisor, and user/handoff waiters visible. Persist archive receipts; an archive incident stays pending/reconciled but never blocks delivery.

## Execution and review

Each executor verifies key, plan/intent revisions, epoch, project, task ref, route, runtime compatibility, and lifecycle, then enters Octopad and reads the live self-contained task plus effective organization/repository instructions. It owns the mission interaction point; a human task never becomes agent work through fallback.

Run deterministic checks first. On return, the supervisor checks artifact revision, actual changed-surface coverage, and saved review class. `targeted` inspects the actual diff/artifact and named checks. `independent` is fresh source-first for product, code, security, privacy, data, migration, or public work; `specialist` adds only a second orthogonal material domain. Green CI does not cover an omitted path. Integrated candidates require integrated review, and applicable adjacent cases include normalization/case, deduplication, authorization, batching, timeouts, empty/zero results, retries, and scale limits.

Accept only explicit verdicts with executed evidence. Silence, timeout, missing checks, or another revision is not PASS. Return stable finding keys to the healthy executor for correction, then targeted-recheck changed artifact and affected criteria. After two `REVISE` with the same key, forbid a blind third loop: diagnose plan/tool/verifier/route and repair or replan. Preserve unrelated PASS. Only the supervisor records accepted PASS or advancement.

At artifact completion (`awaiting-review`), human/handoff wait, or an incident unresolved after bounded recovery, the executor publishes exactly `État`, `Fait`, `Bloqué`, `Décision attendue`, `Pour débloquer`, and `Prochaine étape`; `Aucune` or `Sans objet` is valid. It may receive and transfer a reply. This report is not authority or durable checkpoint evidence until supervisor validation.

## Incidents and replanning

A missing tool, skill, context item, capability, environment, source, or verifier is an incident owned by the supervisor, not automatically a user blocker. Preserve safe independent work, diagnose the failed predicate, restore capability or choose a safe workaround inside the approved envelope, and use one bounded planner/recovery actor when useful. That actor proposes; it cannot claim, launch, persist, or ask the user.

Before escalation, classify mismatch versus incomplete evidence; record a key, evidence, actor/mutation state, and stop boundaries; then verify and receipt at most two distinct safe, reversible remedies in scope. Reuse an existing no-mutation actor before replacement. Connector, `projectId=null`, registry, worktree, branch, dependency, CI, and recoverable tool failures remain execution hygiene while outcome, scope, target, risk, authority, acceptance, and checkpoints stay unchanged. Exhaustion ends the loop; rewording never resets it.

Treat a change as a repair when result, scope, risk, acceptance, route bounds, and protected checkpoints remain unchanged. Record the comparison, execute the smallest correction, review the affected surface, and resume. A non-blocking follow-up gets a stable reason and deduplication key but is not a reporting-only actor in the run.

If task meaning, graph, route bound, authority, protected checkpoint, or acceptance changes, set `replanning`, stop new affected claims, and increment the proposed revision. Let demonstrably independent claimed work finish or fence it. Build a concrete delta and artifact adoption map, run proportionate independent plan review, persist and verify the new essential IDs/edges, then approve the next revision. No old plan-review or affected task PASS transfers.

Contact the user only for a material choice, missing authority, identity unresolved after bounded recovery, unreconcilable duplicate, protected checkpoint, or no compliant route. A real repository/project mismatch, unknown remote, secret/access issue, protected action, destructive recovery, or material scope/target/risk change stops immediately. Record one stable blocker key.

## Human checkpoints and Goal state

Secrets, access grants, spend, destructive effects, required human review, merge, migration application, deployment, publication, and acceptance stay protected. Embed applicable review/merge in the owning E task; separately owned human work may use Hxx. Valid initial authority needs no reapproval for a technically verified head or in-envelope repair; seek new authority only for changed scope, target, risk, or a new protected action. Link a PR to its independently reviewable E task and reconcile post-merge closure evidence. Review cadence and brief approval never complete checkpoints.

A checkpoint blocks only its dependent branch. Continue independent safe work. When no safe frontier remains, update Octopad to `waiting-human` or `paused` under the concurrency guard and publish exactly:

- `État`
- `Fait`
- `Bloqué`
- `Décision attendue`
- `Pour débloquer`
- `Prochaine étape`

Record the handoff receipt idempotently. A rejection preserves artifact and evidence, reopens the same delivery task through repair or replan, and returns to the same checkpoint without duplicating it. An external wake supplies evidence only; refresh the latest intent and verify its exact target/revision before resuming.

Do not mark the native Goal blocked for an ordinary planned checkpoint, a first recoverable incident, or passive waiting while another safe route exists. Keep it active across normal continuation. Use `update_goal(blocked)` only after the same genuine impasse has recurred for three consecutive Goal turns and no meaningful in-scope progress remains. A resumed blocked Goal starts a fresh three-turn audit. Never call a Goal complete merely because a pass ended.

## Resume and close

On resume, follow [state-and-recovery.md](state-and-recovery.md): refresh live Octopad, native state, installed version, and latest user intent; reconcile pending operation keys and creation intents; then continue the current-task supervisor. For an exceptional dedicated handoff, replace the destination only when native evidence proves it terminal or unreachable and guarded epoch rotation succeeds. Absence of observation is not proof.

A dead executor is fenced before a new attempt. If no artifact exists, restart from the saved task; if one exists, adopt or reject it explicitly and review the chosen revision. A predecessor PASS never transfers to a changed artifact.

The supervisor writes Octopad `completed` and calls `update_goal(complete)` only after current global integrated-outcome evidence, required task/review evidence, every checkpoint is satisfied with evidence, final validation, empty pending operations, and every actor is terminal-reconciled or archived. Component or branch completion is insufficient. `waiting-human` and `paused` end a pass but are never terminal success.

The final six-field recap reports artifacts, checks, reviews, human work, repairs, blockers, follow-ups, risks, and actual session/event counts. Include observed tokens, tool calls, compactions, and retries when available; otherwise say unavailable, without estimation. Use returned links and human references, not opaque IDs.

Pause the affected branch only for the strict conditions in the state reference. Stop the whole plan only when shared identity/authority is invalid or no safe agent-owned frontier remains.
