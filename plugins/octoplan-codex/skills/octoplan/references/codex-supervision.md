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

Before native create, verify the v5 creation packet and planned route. After creation, require the full binding readback and observed route before claim, work message, source effect, archive, or PASS. Verify plan/intent, supervisor epoch, authority, identity/target/role, task ID/generation, contract/manifest, context admission, capability, baseline/stack, runtime, budgets, and checkpoint; mismatch permits only stop/rebind/recovery.

Use `planning`, `planned`, `active`, `replanning`, `waiting-human`, `paused`, `completed`, and `superseded`. Review verdicts are evidence, not run states. Every state, intent, or owner change uses the coordination task's `expected_updated_at`; a failed guard causes a reread and authorizes nothing.

Exactly one supervisor epoch owns advancement. The current user task is that supervisor by default and its native Goal supplies persistence across turns. A separate supervisor is chosen and fenced before Goal creation when an unrelated Goal or evidenced environment isolation requires it. Once an unfinished Goal exists, never claim to transfer or fence it through an unsupported primitive, and never falsely complete/block it to enable handoff. Never create a reporting-only parent or two competing Goals/heartbeats.

Keep the supervisor thin: it owns authority, state, receipts, lifecycle, acceptance, and dispatch, but delegates long exploration and material replanning to one bounded fresh PLN. Persist `delegation_boundary` with inputs, maximum report shape, route/readback, and output; consume that report, not raw history. Before substantive work at each wake, refresh `supervisor.context_admission` against current plan/intent/epoch/state hash. Active work requires `REUSE`; an unhealthy Goal owner records `PAUSE`, only reconciles/delegates through a fresh analytical lease, and keeps ownership. `REPLACE` is valid only inside a proved fenced takeover.

## Supervisor loop

At every wake:

1. refresh the coordination task, native Goal, installed skill version, latest intent, pending operation keys, open checkpoints, current task statuses, and relevant native sessions;
2. reconcile pending writes and actor intents before issuing new ones;
3. rank the critical path and persist `parallel_safe_now`, `blocked_on_artifact_refs`, and `write_conflict_set` from dependencies, checkpoints, conflicts, admitted routes, fresh stacks, capabilities, and budgets;
4. launch up to bounded capacity, then backfill from the remaining safe frontier after reconciliation;
5. collect artifacts and run the saved review class;
6. record accepted receipts, review outcomes, completion, incidents, and any timed external wake;
7. continue independent safe work until a real pause condition remains.

Use Octopad's graph/statuses directly; do not mirror a scheduler. The coordination task stays `in_progress` until terminal. A delivery task is `todo` until claimed, `in_progress` from claim through review and embedded checkpoints, `blocked` only by an evidenced task-level blocker, and `done` only after accepted evidence and final gates. Never send `waiting-human` or `paused` as an Octopad task status.

Exclude candidates conflicting in files, symbols, artifacts, migrations, lockfiles, scarce resources, checkpoints, routes, or budgets. Repetitive independent items use bounded partial batches with individual artifacts, receipts, and verdicts. Never require all-ready activation: fill available WIP, reconcile, then backfill.

At every actor safe boundary, reread `intent.revision` before the next external effect. A natural-language pause, cancellation, reprioritization, replacement, diagnostic limit, or “do not send” becomes durable state first; only then message affected actors. Stale actors stop or finish only the explicitly safe boundary recorded by the new intent. Do not rely on conversation memory or a user-facing command grammar.

Follow active native tasks with compact cursor-based `wait_threads`; a task's commentary or silence is not plan state. Create at most one heartbeat per plan, and only for a timed external predicate such as CI, human merge, or deployment evidence when native waiting cannot persist the wake. Its prompt must refresh the coordination task and current intent/checkpoint before acting, never embed a copied blocker. Update or delete it when intent or predicate changes, and remove it on completion. Never heartbeat active Codex actors or use one as a second supervisor.

Apply the SKILL user-visible identifier rule to recaps. Internal prompts, ledger records, arguments, and creation records retain the full correlation identifiers.

## Native actors

Only the current supervisor claims tasks, creates/messages/archives actors, starts reviewers, validates authority/checkpoints, records accepted outcomes, and advances the graph. Executors may relay a received answer to it but never validate advancement, change route, or launch.

Persist creation intent first. Every title is `<PREFIX>-<short-work-stream-name>-<short-task-name>`: `SUP` supervisor; `EX` executor/follow-up; `PLN` planner/recovery; `REV` plan/lead/specialist reviewer. Normalize non-empty components, shorten the stream first, then the task only if still needed, to fit 64 characters; never emit an empty component. Omit `octoplanned`; opaque IDs stay in prompt/state. Examples: `SUP-company-brain-delivery`, `EX-company-brain-work-graph`, `PLN-company-brain-replan`, `REV-company-brain-work-graph`.

The first child prompt says `Use $octoplan as <role>`, names its role pack, and carries the creation key, full binding, autonomous manifest, schema, and minimum version. The actor must return binding/manifest readbacks and observed route before work. Create once; reconcile uncertain dispatch by key/evidence and never retry to improve a response.

Only an actor with current supervisor epoch and task generation may activate. Writer replacement rotates only the affected task generation: persist replacement intent, obtain stop acknowledgement and quiescence, then activate the fresh writer after create/binding/manifest receipts. Supervisor epoch changes only for supervisor takeover, so healthy parallel actors stay valid. Read-only preparation may start earlier; archive order never substitutes for quiescence.

Reconcile only changed keys, lifecycle, artifacts, reviews, checkpoints, intent, runtime, and sources. A session/title is evidence, never identity, authority, completion, or receipt. Before substantial resume after compaction/superseded intent, and after two comparable resumes without accepted progress, persist context admission; a third such resume must replace or pause rather than reuse.

Normal lifecycle remains `active -> awaiting-review -> correction-needed|handoff-pending -> terminal-reconciled -> archived|archive-pending`. Generation replacement uses predecessor `fence-pending -> fenced -> terminal-reconciled` and successor `created-pending -> active`. Reuse only for a stable correction on the same artifact/generation/contract/base with context admission; preserve waiters. Archive completed executors after PASS/reconciliation; archive failure remains pending and blocks close.

## Execution and review

Each executor verifies its full binding, observed route, actor-bound baseline lease/stack snapshot, fresh-session receipt when required, context admission, and manifest acknowledgement, then reads the live task and effective rules. Before first source effect it refreshes the stack gate. A human task never becomes agent work through fallback.

Run deterministic checks first. On return, the supervisor checks artifact revision, actual changed-surface coverage, and saved review class. `targeted` inspects the actual diff/artifact and named checks. `independent` is fresh source-first for product, code, security, privacy, data, migration, or public work; `specialist` adds only a second orthogonal material domain. Green CI does not cover an omitted path. Integrated candidates require integrated review, and applicable adjacent cases include normalization/case, deduplication, authorization, batching, timeouts, empty/zero results, retries, and scale limits.

Accept only explicit verdicts with typed review evidence. A stable correction on the same generation may return to the healthy executor and same reviewer for `targeted_recheck`. Any scope, graph, contract, route, acceptance, or generation change requires a new writer where applicable and `full_independent_fresh` reviewer. After two `REVISE` with the same key, diagnose plan/tool/verifier/route before another pass; changing reviewer never resets the counter. Preserve unrelated PASS.

At artifact completion (`awaiting-review`), human/handoff wait, or an incident unresolved after bounded recovery, the executor publishes six semantic fields—state, done, blocked, decision expected, to unblock, next step—with labels and content localized to the user's language; the local equivalent of “none” is valid. It may receive and transfer a reply. This report is not authority or durable checkpoint evidence until supervisor validation.

Compact example for an English-speaking user: **State:** method review; **Done:** pilot ready; **Blocked:** repeated artifacts; **Decision expected:** approve or revise; **To unblock:** review the pilot; **Next step:** safe work continues, then the batch resumes.

## Incidents and replanning

A missing tool, skill, context item, capability, environment, source, or verifier is an incident owned by the supervisor, not automatically a user blocker. Preserve safe independent work, diagnose the failed predicate, restore capability or choose a safe workaround inside the approved envelope, and use one bounded planner/recovery actor when useful. That actor proposes; it cannot claim, launch, persist, or ask the user.

Before escalation, classify mismatch versus incomplete evidence; record a key, evidence, actor/mutation state, and stop boundaries; then verify and receipt at most two distinct safe, reversible remedies in scope. Reuse an existing no-mutation actor before replacement. Connector, `projectId=null`, registry, worktree, branch, dependency, CI, and recoverable tool failures remain execution hygiene while outcome, scope, target, risk, authority, acceptance, and checkpoints stay unchanged. Exhaustion ends the loop; rewording never resets it.

Treat a change as repair only when result, scope, risk, graph, route, acceptance, authority, generation, manifest, artifact identity, and base remain unchanged. Record that comparison, reuse the healthy writer, make the smallest correction, and targeted-recheck it.

If a task splits/merges or changes meaning, outputs, Done when, graph, route, authority, checkpoint, acceptance, artifact contract, or rewrite policy, set `replanning`, increment affected generations, expire prior planner leases, and make predecessor writers ineligible. Fence/quiesce them; launch one fresh planner on a bounded source snapshot; build manifests and artifact dispositions; run `full_independent_fresh`; persist the new graph/bindings; then activate fresh writers. No old eligibility or affected PASS transfers.

After two material replans without newly accepted progress, a repeated graph hash, or two comparable execution/review cycles without accepted progress, open a structured `replan|efficiency` incident. Until its diagnosis and consolidated disposition are adopted, forbid actionable writers and create/work messages; allow only reconciliation, stop, archive, and bounded diagnosis. Stable correction may resume after adoption. Tokens, compactions, drafts, commits, irrelevant green CI, and review activity are not accepted progress.

Contact the user only for a material choice, missing authority, identity unresolved after bounded recovery, unreconcilable duplicate, protected checkpoint, or no compliant route. A real repository/project mismatch, unknown remote, secret/access issue, protected action, destructive recovery, or material scope/target/risk change stops immediately. Record one stable blocker key.

## Human checkpoints and Goal state

Secrets, access grants, spend, destructive effects, required human review, merge, migration application, deployment, publication, and acceptance stay protected. Embed applicable review/merge in the owning E task; separately owned human work may use Hxx. Valid initial authority needs no reapproval for a technically verified head or in-envelope repair; seek new authority only for changed scope, target, risk, or a new protected action. Link a PR to its independently reviewable E task and reconcile post-merge closure evidence. Review cadence and brief approval never complete checkpoints.

A checkpoint blocks only its dependent branch. Continue independent safe work. When no safe frontier remains, set the coordination JSON state to `waiting-human` or `paused` under the concurrency guard, keep the Octopad coordination task `in_progress`, and publish the localized six-field handoff above.

Record the handoff receipt idempotently. A rejection preserves artifact and evidence, reopens the same delivery task through repair or replan, and returns to the same checkpoint without duplicating it. An external wake supplies evidence only; refresh the latest intent and verify its exact target/revision before resuming.

Do not mark the native Goal blocked for an ordinary planned checkpoint, a first recoverable incident, or passive waiting while another safe route exists. Keep it active across normal continuation. Use `update_goal(blocked)` only after the same genuine impasse has recurred for three consecutive Goal turns and no meaningful in-scope progress remains. A resumed blocked Goal starts a fresh three-turn audit. Never call a Goal complete merely because a pass ended.

## Resume and close

On resume, refresh live state and pending intents, then revive the exact saved supervisor first: read it, restore archive state only under existing lifecycle authority, wake once, and reconcile. Silence or absence is not proof of failure.

Create a `recovery-successor` only when native evidence proves the saved owner terminal or unreachable and authority still covers it. First persist `OCTOPLAN_TAKEOVER_INTENT`; one guarded update then fences the predecessor by rotating owner/mode/epoch and records a pending successor Goal. After successful readback, obtain a fresh post-fence `effects_quiescent_ref`; only then create, receipt, and activate the successor Goal. Ambiguity reconciles. The old Goal is historical, never falsely completed or blocked, and any wake fails the new epoch.

A dead or generation-stale writer is fenced and quiesced before a successor activates. Adopt, reject, or rewrite its artifact explicitly in the new manifest. Base drift alone permits read-only rebind when the contract is unchanged; a writer starts from a clean base/worktree, and requires a fresh session when drift changes generation/contract or clean adoption is impossible.

Track each branch/PR/document from `branch-only` through `draft`, `ready-for-review`, `waiting-human`, and `merged|closed|superseded`. At every transition and wake, refresh exact base/head, owner, blocker, next transition, resume predicate, disposition, and evidence. Baseline refresh occurs only at the declared lifecycle gates or an evidenced collision; unrelated drift does not create a rebase treadmill. A draft without this record is orphan debt and blocks terminal reconciliation/close.

The supervisor sets coordination JSON to `completed`, marks its Octopad task `done`, and calls `update_goal(complete)` only after current global integrated-outcome evidence, required task/review evidence, every checkpoint is satisfied, final validation, no pending operation, orphan/unresolved delivery artifact, or `archive-pending` actor, every completed executor is archived, and every other actor is terminal-reconciled or archived. Supersession also requires terminal/disposed artifacts. Component or branch completion is insufficient. `waiting-human` and `paused` end a pass but are never terminal success.

The final six-field recap reports actor/planner reused or replaced and why, generation/lease, artifact and draft dispositions, material-replan streak, context admissions, accepted progress, review type, reviewer sessions versus passes, safe parallel work, and typed metrics with population/window/source. Unavailable remains unavailable; never combine Goal, session, auditor-context, or tool-output token populations.

Pause the affected branch only for the strict conditions in the state reference. Stop the whole plan only when shared identity/authority is invalid or no safe agent-owned frontier remains.
