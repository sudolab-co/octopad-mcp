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

Before native create, verify the v6 role packet and planned route. After creation, require binding, production Octopad context, and observed-route readbacks before work, effect, archive, or PASS. The binding covers plan and intent revisions, supervisor epoch, authority, identity, task generation, manifest, target, and artifact versions; mismatch permits only stop or recovery.

Use `planning`, `planned`, `active`, `replanning`, `waiting-human`, `paused`, `completed`, and `superseded`. These are recovery conditions, not a progress mirror; task statuses remain authoritative. Every state, intent, or owner change uses the state host's `expected_updated_at`; a failed guard causes a reread and authorizes nothing.

Exactly one supervisor epoch owns advancement. The current user task is supervisor by default; its native Goal is only a continuity/wake handle, never shared plan or progress truth. A separate supervisor is chosen and fenced before Goal creation only when evidenced project or runtime isolation requires it. Never create a reporting-only parent, competing Goal, or unsupported Goal transfer.

Keep the supervisor thin: it owns authority, compact state, receipts, actor and artifact lifecycle, integration, and dispatch. Delegate long exploration, material re-decomposition, or orthogonal review only with a bounded packet and report shape; consume the report, not raw history.

## Supervisor loop

At every wake:

1. start or refresh the production Octopad session, state host, exact graph, native Goal/tasks, installed skill, and latest user intent;
2. reconcile pending writes/actions, active actors, artifact versions, and open checkpoints before issuing a new effect;
3. derive the safe frontier from live dependencies, protected gates, real write conflicts, admitted routes, and active actors;
4. execute inline or launch only the bounded actors whose benefit exceeds handoff cost; parallelize only independent work;
5. collect artifacts, run their saved review class, integrate the current candidate, and record accepted evidence;
6. handle obstacles within the recovery budget, replan material change, and continue every independent safe branch.

Use Octopad's graph and statuses directly; do not mirror a scheduler. The outcome task hosts state and stays `in_progress` through integration, review, and gates; it becomes `done` only on accepted integrated proof. `waiting-human` and `paused` exist only in compact recovery state.

For `simple` work default to one active delivery path. For `structured` or `adaptive` work fill only independent WIP supported by current capacity and conflict evidence, then backfill after reconciliation. Repetitive items use bounded partial batches with individual artifacts and verdicts.

At every actor safe boundary, reread `intent.revision` before the next external effect. Persist a natural-language pause, cancellation, reprioritization, or “do not send” before an instruction-changing actor directive. A stale actor stops at the recorded safe boundary.

Follow native tasks with compact cursor-based waits; commentary or silence is not plan state. Use at most one timed wake only for a real external predicate when native waiting cannot persist it. The wake refreshes current state and intent before acting and never becomes a second supervisor.

Apply the SKILL user-visible identifier rule to recaps. Internal prompts, ledger records, arguments, and creation records retain the full correlation identifiers.

## Native actors

Only the supervisor creates, messages, or archives actors; validates authority and checkpoints; accepts artifacts; and advances the graph. Executors may relay an answer but never validate advancement, change route, or launch.

Persist creation intent first. Every title is `<PREFIX>-<short-work-stream-name>-<short-task-name>`: `SUP` supervisor; `EX` executor/follow-up; `PLN` planner/recovery; `REV` plan/lead/specialist reviewer. Normalize non-empty components, shorten the stream first, then the task only if still needed, to fit 64 characters; never emit an empty component. Omit `octoplanned`; opaque IDs stay in prompt/state. Examples: `SUP-company-brain-delivery`, `EX-company-brain-work-graph`, `PLN-company-brain-replan`, `REV-company-brain-work-graph`.

The first child prompt says `Use $octoplan as <role>`, names its role pack, requires a production Octopad session and exact context, and carries the creation key, full binding, autonomous manifest, schema, and minimum version. The actor returns binding, manifest, Octopad-context, and observed-route readbacks before work. Create once; reconcile uncertain dispatch and never retry merely to improve a response.

Only an actor with the current supervisor epoch, task generation, manifest, context, and artifact versions may act. Replacement rotates the affected task generation: persist intent, stop and prove effects quiescent, disposition prior artifacts, then activate a fresh bound actor. Supervisor epoch changes only for supervisor takeover.

Reconcile only unresolved actions, active actors, artifacts, checkpoints, current intent, and changed sources. A session or title is evidence, never identity, authority, or completion. Reuse only for a stable correction on the same task generation, manifest, and artifact versions. Archive a terminal actor after its output and lifecycle reconcile; archive ambiguity remains pending and blocks close.

## Execution and review

Each executor verifies its binding, observed route, Octopad context, manifest, and artifact versions, then reads the live task and effective rules. Repository work refreshes exact base/head before source mutations; other profiles refresh their own versions and verifier evidence. A human task never becomes agent work through fallback.

Run deterministic checks first. On return, the supervisor verifies every exact artifact version, changed-surface coverage, profile evidence, and the review class derived from that task's consequence. `targeted` inspects the artifacts and named checks; `independent` adds one fresh source-first review for material work; `specialist` adds only a second orthogonal material domain. One coherent task may integrate several profiles in the same review. The plan-level maximum never raises unaffected tasks. Integrated candidates require integrated review.

Accept only explicit verdicts with typed evidence. A stable correction may return to the healthy executor and same reviewer for targeted recheck. Scope, graph, contract, route, acceptance, or generation change requires a material replan and fresh review. Two `REVISE` verdicts with the same key trigger diagnosis before another pass; changing reviewer does not reset the loop.

At artifact `ready`, human/handoff wait, or an incident unresolved after bounded recovery, the executor publishes six semantic fields—state, done, blocked, decision expected, to unblock, next step—with labels and content localized to the user's language; the local equivalent of “none” is valid. It may receive and transfer a reply. This report is not authority or durable checkpoint evidence until supervisor validation.

Compact example for an English-speaking user: **State:** method review; **Done:** pilot ready; **Blocked:** repeated artifacts; **Decision expected:** approve or revise; **To unblock:** review the pilot; **Next step:** safe work continues, then the batch resumes.

## Incidents and replanning

A missing tool, skill, context, environment, source, or verifier is an incident owned by the supervisor, not automatically a user blocker. Preserve safe independent work, diagnose the failed predicate, restore capability or choose an in-envelope workaround, and use one bounded planner or recovery actor when that improves diagnosis. It proposes and cannot claim, launch, write Octopad, or ask the user.

Classify each obstacle:

1. `transient`: retry once with the same operation key;
2. `evidence-gap`: refresh the authoritative source and never infer;
3. `in-envelope`: try at most two distinct safe, reversible remedies;
4. `material`: create a new plan revision and one fresh plan review;
5. `protected`: open or resume the named human checkpoint.

Record the classification, evidence, mutation state, attempts, and resume predicate. Rewording, waking, or replacing an actor never resets the ceiling.

Treat a change as repair only when outcome, scope, consequence, graph, route, acceptance, authority, generation, manifest, and artifact identity remain unchanged. Reuse the healthy actor, make the smallest correction, and targeted-recheck it.

If a task splits or merges, or meaning, output, Done when, graph, route, authority, checkpoint, acceptance, or artifact contract changes, set `replanning`, increment affected generations, stop old actors, disposition their artifacts, and build a new candidate. Use a fresh bounded planner only when re-decomposition benefits from isolation. Run exactly one fresh plan review for the new revision, persist it, then activate fresh actors. Old eligibility and affected PASS do not transfer.

After two material replans or two comparable work/review cycles without newly accepted artifact, review, or integrated evidence, open one efficiency incident. Diagnose plan, context, tool, verifier, route, actor topology, and task size before another work actor. Activity, tokens, drafts, commits, or irrelevant green checks are not progress.

Contact the user only for a material choice, missing authority, identity unresolved after bounded recovery, unreconcilable duplicate, protected checkpoint, infeasibility, or no compliant route. Record one stable blocker key and keep independent safe work moving.

## Human checkpoints and Goal state

Secrets, access grants, spend, destructive effects, required human review, merge, migration application, deployment, publication, and acceptance stay protected as `Cxx` checkpoints in the owning E task. Use `Hxx` only for a distinct human-produced artifact, never for an approval, review, merge, publication, or other gate. Valid authority needs no reapproval for an in-envelope repair; seek new authority only for changed scope, target, consequence, or protected action. Review cadence and brief approval never complete a checkpoint.

A checkpoint blocks only its dependent branch. Continue independent safe work. When no safe frontier remains, set control status to `waiting-human` or `paused` under the concurrency guard, keep affected delivery tasks open, and publish the localized six-field handoff above.

Record the handoff receipt idempotently. A rejection preserves artifact and evidence, reopens the same delivery task through repair or replan, and returns to the same checkpoint without duplicating it. An external wake supplies evidence only; refresh the latest intent and verify its exact target/revision before resuming.

Do not mark the native Goal blocked for an ordinary planned checkpoint, a first recoverable incident, or passive waiting while another safe route exists. Keep it active across normal continuation. Use `update_goal(blocked)` only after the same genuine impasse has recurred for three consecutive Goal turns and no meaningful in-scope progress remains. A resumed blocked Goal starts a fresh three-turn audit. Never call a Goal complete merely because a pass ended.

## Resume and close

On resume, refresh production Octopad state, native Goal/tasks, and pending actions, then wake the exact saved supervisor first. Silence or absence is not proof of failure.

Create a recovery successor only when native evidence proves the saved owner terminal or unreachable and authority still covers it. Persist takeover intent, guard the owner/epoch rotation, reread it, and prove post-fence effect quiescence before creating one successor. The old Goal stays historical and any late wake fails the new epoch.

A dead or stale actor is stopped and quiesced before a successor activates. The new manifest explicitly adopts, rejects, or rewrites its artifact. Version drift permits read-only refresh when the contract is unchanged; material drift creates a new generation.

Track every artifact through `draft`, `ready`, `waiting-human`, and `terminal` using its generic core and profile evidence. Refresh its version at dispatch, effect, review, handoff, and any evidenced collision. A draft without a lifecycle record is orphan debt and blocks close.

Set control status to `completed`, mark the outcome task done, and complete the Goal only after current integrated-outcome proof, required task/review evidence, every checkpoint satisfied, final validation, no pending action, no active actor, and every artifact terminal with a non-active disposition. Component completion is insufficient; `waiting-human` and `paused` are not success.

The final localized six-field recap reports accepted outcome evidence, current revision, actor reuse or replacement, artifact dispositions, review session and passes, remaining safe work, and every open checkpoint or incident.

Pause the affected branch only for the strict conditions in the state reference. Stop the whole plan only when shared identity/authority is invalid or no safe agent-owned frontier remains.
