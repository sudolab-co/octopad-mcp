# Codex conditional supervision

Read this file only after valid launch authority or a request to resume a run. Octopad is authoritative; native Codex state is evidence about sessions only.

A missing `octoplan-supervision-v4` contract stops before any native execution action. Replan from current Octopad state. Before a new run, inventory legacy threads and artifacts; every live legacy owner must be conclusively stopped or its immutable result explicitly adopted into the new lineage. Never create a v6 attempt while an ambiguous legacy executor may still own the same task.

## User-facing output

Apply the skill's opaque-identifier rule only to messages rendered to the user, including supervisor recaps. It must not be applied to internal supervisor, executor, reviewer, or recovery prompts, ledger comments, tool arguments, exact commands, or creation records: those must retain the full correlation identifiers required by this protocol. In a user-visible message, never print a raw UUID, session/client/host/run/attempt ID, owner token, SHA-256 value, or Git commit hash as visible text or inline code. Use a human-readable title, name, role, branch, or commit subject. A Codex session reference must use a readable Markdown label with the native deep link `[<title or role>](codex://threads/<thread-id>)`; keep the real thread ID only in the link destination. Internal ledger records, tool arguments, exact commands, and required Markdown link destinations may retain those identifiers. Never emit them as bare URLs or visible labels in a user-visible message. PR numbers, migration numbers, task numbers, and `#N` ranks remain allowed.

## Choose the current mode

Apply the saved `octoplan-supervision-v4` policy at launch or after a necessary takeover. Use a dedicated supervisor when any saved predicate is true:

- at least four delivery tasks remain, excluding final validation and normally requiring at least eight executor/reviewer completion wakes;
- parallel fan-out or fan-in remains;
- multiple streams share the run;
- at least two tasks remain across a human, external, or explicit interruption gate.

Otherwise supervise inline. An existing valid dedicated parent may finish a smaller remainder. Goal mode is optional only when the user explicitly requested it; it never proves approval, ownership, state, or completion.

## Contract and ledger

Use comments on the saved coordination-ledger task. For one stream this is its final-validation task; every tracker in a multi-stream run must point to the same immutable task ID.

Planning already saved one Plan manifest containing participant IDs, validation mode, repair envelope, follow-up policy, routes, exact native execution targets, defaults, review routes, and the reviewed SHA-256. Task and tracker content remains at source. Reconstruct it by the planning reference's Fingerprint rules. Missing pointers, fields, matching plan-review PASS, targets, or hashes stop.

After consent and before any claim, verify this session's actual model, effort, target, and environment equal the saved inline route and inline supervisor target. Then guardedly append the first run record: unique run ID, exact approved hash, approval source thread and time, state `active`, current mode, route, target, and environment, fresh inline owner token, supervisor epoch 1, zero dedicated replacements used, and no candidate. The approved hash must still equal the manifest and live plan.

Append every ledger transition with `tasks(action: "update")` and the current `expected_updated_at`. The latest successfully guarded comment wins; a failed update grants no authority. Run states are `active`, `waiting-human`, `paused`, `failed`, `superseded`, `revoked`, and `completed`. `active` authorizes planned agent work. `waiting-human` authorizes event reconciliation only; on a valid rejection or repairable gate change, the supervisor first transitions back to `active`. Only the fenced supervisor may write `completed`, after final validation and every human task required by the definition of success are durably done.

## Supervisor ownership

Every inline or dedicated supervisor has a unique owner token and monotonically increasing supervisor epoch. The latest owner entry also stores current mode, route, target, and environment plus dedicated thread and host IDs when applicable.

Before every claim, creation, steering action, run transition, successor launch, and after every wake:

1. reread the ledger and the changed participant or artifact since the last durable reconciliation cursor; reconstruct the full fingerprint only at launch, takeover, an unexpected update to a fingerprinted entity, missing cursor, or ambiguous lineage;
2. verify the run is `active` for planned work, or `waiting-human` only for event reconciliation that must transition the run before any planned claim;
3. verify this owner token and supervisor epoch match the latest entry;
4. for a dedicated parent, verify its exact thread and host IDs plus the matching target and environment saved at activation;
5. stop without side effects on any mismatch.

Epoch changes fence supervisors only. Child authority remains bound to run ID, fingerprint, task claim, and attempt ID.

## Safe thread creation

Every supervisor, executor, reviewer, and recovery creation uses one durable creation record keyed by run, task or candidate, attempt, role, route, native target and environment, and artifact revision when applicable. Guardedly save a unique token and `intent` before calling `create_thread` once. Use the human-readable title defined below. Start the first native prompt with the full key and token, never the human-readable title. Require no work until the exact record is `activated`. Save `pending` only with a returned `clientThreadId`; save `ready` only after real thread and host IDs plus the actual target and environment uniquely match the record. Save `target-mismatch` with the resolved actual identity and pause when they do not match. Save `activated` only after supervisor transfer or a guarded child start, and `failed` only after authoritative terminal failure and no unique native match.

Derive the plain work-stream name by removing one terminal ` (octoplanned)` suffix from the saved stream title and preserving every other character. Before title construction, reject and pause on any stream or task-title scalar in U+0000–U+001F or U+007F–U+009F, either line separator U+2028–U+2029, or any bidi control U+061C, U+200E–U+200F, U+202A–U+202E, or U+2066–U+2069. Do not remove, replace, normalize, or silently display those characters. Use these exact native titles:

- Supervisor title: `supervisor - <plain work stream name>`. Use it for a dedicated supervisor and every dedicated-supervisor replacement. A multi-stream dedicated supervisor uses the plain name of the ledger-owning stream.
- Executor title: `<plain work stream name> - #<N> <task name>`. Use it for the first executor, fallback, repair, and same-role executor recovery. A repair executor, including one created for a run-scoped repair subtask, derives this visible title from the ranked parent delivery task, never from the repair-subtask title.
- Lead reviewer title: `review - <plain work stream name> - #<N> <task name>`. Use it for the first lead reviewer and same-role lead-reviewer recovery.
- Specialist reviewer title: `specialist review - <plain work stream name> - #<N> <task name>`. Use it for the first specialist reviewer and same-role specialist-reviewer recovery.

Every executor or reviewer uses the plain name of the stream that owns its task. Derive `N` and `<task name>` only from that task's saved `#N - <task name>` title, or from the ranked parent delivery task for a repair subtask. If the required source title cannot be parsed as `#N - <task name>`, pause before creation. Repeated attempts may share a visible title: the durable record and first prompt, not the title, distinguish them.

The first prompt line is exactly `OCTOPLAN_CREATION ` followed by one compact UTF-8 JSON object with these keys in lexicographic order and no insignificant whitespace:

```json
{"artifact_revision":"<artifact revision>","attempt_id":"<attempt ID>","environment":"<saved environment>","role":"<saved role>","route":"<saved route>","run_id":"<run ID>","subject_id":"<task or candidate ID>","subject_kind":"<task|candidate>","target":{"directory_name":"<projectless directory name>","environment":"<local|worktree>","kind":"<project|projectless>","project_id":"<project ID>","rationale":"<projectless rationale>"},"token":"<creation token>"}
```

Replace each angle-bracket placeholder with its saved value. Use JSON `null`, not the string `"null"`, for every inapplicable scalar. The nested target uses the five binding fields already saved in the creation record; project targets set `directory_name` and `rationale` to `null`, while projectless targets set `project_id` and `environment` to `null`. Keep object keys in the displayed order. For every string, emit Unicode scalar values directly as UTF-8 except quotation mark as `\"`, reverse solidus as `\\`, and U+0000–U+001F as lowercase `\u00xx`; never escape `/` or a non-ASCII scalar. Reject an unpaired surrogate and emit no insignificant whitespace. The durable creation record stores this exact line before `create_thread`; later prompts and records may carry additional fields but never alter it.

Before saving `intent`, call `list_projects` and uniquely reconcile the saved project ID and environment; retain current host, canonical path, and Git flag as non-binding audit evidence. For an explicit projectless target, verify its saved directory name and rationale. Never infer a target from the caller's cwd, a source pointer, a task type, or the absence of a project field. A target mismatch pauses without creating or steering a thread.

Never pass a client ID to thread tools. After the one `create_thread` call, apply the same resolver regardless of response shape:

- With a returned `clientThreadId`, save `pending`. Call `list_threads` until its result maps that client ID to a real thread ID or reports authoritative terminal failure. Comparing the client ID inside `list_threads` results is allowed; passing it to `read_thread`, `wait_threads`, or another thread tool is not.
- With a returned real thread ID, treat it as the first candidate but do not save `ready` before full enumeration and verification.
- With no visible result, keep `intent`, call `list_threads`, enumerate every current real-thread candidate, and do not call `create_thread` again.

After every response shape, call `list_threads` and enumerate every current real-thread candidate before `ready`. For every real candidate, use `read_thread` and match the complete `OCTOPLAN_CREATION` line in its first prompt. Reconcile only one exact match and never retry while creation is ambiguous. Save `ready` only after that thread's real thread ID, host ID, target, and environment match the record. Save `target-mismatch` on a unique wrong-target match. A still-pending client, zero exact matches without terminal evidence, or multiple exact matches stays nonterminal and pauses without another creation call. Save `failed` only after authoritative terminal failure and proof that no exact native match exists.

## Bootstrap a dedicated parent

The planning or recovery session remains inline owner until transfer finishes.

1. Reconcile and use the exact saved dedicated supervisor target and environment, then use Safe thread creation with the candidate token as identity. Use the required supervisor title and start its first prompt with the full creation key and token; do not embed a proposed epoch.
2. Tell it to create nothing until the ledger names its token and real IDs; before activation it returns only `awaiting activation: <token>`.
3. The inline owner guardedly transfers ownership at its current epoch plus one, saves the real IDs, and marks `activated`.
4. Send one activation/reconcile message. The parent rereads the ledger before acting.

If the bootstrap owner disappears, recovery takes a newer inline epoch while preserving the candidate record, then uniquely recovers and activates it at the next epoch. Relaunch only after authoritative native state proves failure and no matching thread exists. Every candidate after the first consumes the saved dedicated-replacement bound, whether its predecessor failed before or after activation and regardless of takeover cause. A resume or replacement request does not add a candidate; when the bound is exhausted, continue inline.

## Reconciliation loop

The fenced supervisor repeats this loop from durable state, not conversation memory:

1. Reread the ledger plus entities changed since the last durable reconciliation cursor, and persist the next cursor. At launch, takeover, missing cursor, unexpected plan-entity update, or ambiguity, reread every participating tracker, task, dependency, attempt, artifact, review, gate, and saved thread record.
2. Verify ownership and the approved hash. Recompute the full fingerprint only when step 1's full-reconstruction predicate fires; otherwise verify that no fingerprinted field appears in the changed set.
3. Inspect saved native threads. Recover only unique matches.
4. Resolve the ready frontier from dependencies; `Next` and rank are explanations only.
5. Resolve all ready tasks by ownership. Skip human-only tasks and blocked branches while another safe agent-owned task or complete saved symmetric parallel group is ready. When no safe agent-owned frontier remains and at least one human task gates completion, transition the run to `waiting-human`, send the supervisor recap, and sleep. Stop the affected branch at placeholders, unmet preconditions, foreign assignments, missing routes, plan drift, or protected actions; continue unrelated ready branches.
6. Preflight that task or group. Claim each task with current `expected_updated_at`; if a group claim fails, release every unlaunched claim acquired by this owner, reread, and create nothing from the failed set.
7. Persist an attempt ID `<task ID>@<claimed updated_at>` plus exact immutable base revision and lineage resolved from the contract default or saved override.
8. Use `list_projects` to reconcile the exact default executor target or task-role override. Create the thread at that exact target and environment, with a fresh worktree only when the saved target says `worktree`. Use Safe thread creation at the exact saved route. Reviewers use their task-role override or inherit the executor creation record's target; same-role recovery inherits the superseded creation record's target.
9. Monitor with `wait_threads` and current cursors. Use `send_message_to_thread` only for a concrete blocker, correction, activation, or resume. Treat every child message as a wake signal and reread Octopad before transition.

At fan-out, create every member but keep all records at `ready` until the complete group has real IDs. Then activate the whole group in one guarded transition. An unresolved member activates none. At fan-in, wait for durable completion of every dependency and save one explicit integrated revision before the successor or final validation.

## Executor and review prompts

Start every executor prompt with creation token, task ID, run ID, attempt ID, role, route, target, environment, and base revision. Require it to do no work until its creation record is `activated`, verify its actual target and environment once before work, call Octopad `build_context`, and reread exact sources. After every wake and before artifact writes, it verifies the active run, approved hash through the ledger plus current reconciliation cursor/delta guard, activated creation record, current attempt, route, and base. It reconstructs the full fingerprint only under the Reconciliation loop's named triggers; a mismatch stops without writes.

The executor produces and verifies one durable artifact and saves one unambiguous current immutable artifact revision with target and environment provenance copied from its creation record. For targeted review it runs the saved deterministic adversarial checks in the same context, records the scoped PASS, verifies the agent-owned Done when, and marks the delivery task done with the current guard. For independent or specialist review it uses Safe thread creation for the saved fresh lead and any `Specialist review route`, implements corrections, and never marks the task done. No executor launches a successor.

Before work, after every wake, and before any write, PASS, or completion, each independent reviewer verifies its activated creation record, active run, approved hash through the current cursor/delta guard, current attempt and review record, mandate, route, and exact artifact revision. Full fingerprint reconstruction follows only the Reconciliation loop's named triggers. Before first work it additionally verifies its actual target and environment once. A mismatch stops without writes. Each reviewer opens that revision independently. A specialist reports only to the lead and never completes or relays. The lead coordinates corrections, requires every saved reviewer PASS on the affected current revision, verifies the agent-owned `Done when`, marks the delivery task done, and never launches a successor. A new code or content revision invalidates every PASS over that surface. A metadata-only revision invalidates only its targeted metadata PASS when the underlying artifact revision is unchanged.

Only the supervisor rereads durable completion, checks that no result invalidated a future assumption, dependency, integration base, or success definition, and then claims successors. `in_progress` means an agent currently owns work. A delivery task waiting only for a human action is done; the separate human task carries the wait. Before every user-facing pause or completion, reconcile all participant statuses so no task remains `in_progress` without an active owner and reason.

## Adaptive incidents

When an executor, reviewer, external event, or preflight reveals a problem, the supervisor records the evidence and classifies it against the confirmed brief:

1. **Repair.** The issue blocks one approved task and stays within its result, scope, risk, acceptance, route bounds, and protected-action boundary. Before any repository, artifact, task-status, or child-session write, guardedly save a repair intent comparing each predicate with exact evidence and stating why no fingerprinted field changes; any unknown or failed predicate is a replan. Targeted self-review is allowed only when every classification predicate and artifact check is mechanically provable. If classification needs judgment, the saved independent lead reviews and passes the repair intent before artifact work, remains the lead for the finished repair, and is not duplicated. The ledger record is the default audit trail. Create a run-scoped repair subtask with Why, What, impact, parent ID, issue evidence, expected artifact surface, and acceptance only when the repair needs separate ownership, a distinct route, or persistence across a wake. Keep the parent `in_progress` or reopen it to `in_progress`; allow one active repair, two sequential repairs per parent, and depth one. Reuse the uniquely identified current-attempt executor only while its thread is resumable and its route, target, base, and authority still match. Otherwise create a fresh repair agent at the saved route. Review every affected surface at the highest saved adequate class among them; add a specialist only when two affected surfaces are genuinely orthogonal and one is materially weak to verify. Preserve unrelated PASS records, close the repair record and optional subtask, then resume the parent.
2. **Follow-up.** The issue does not block the active definition of success. Build a stable key from the source task ID, source artifact revision, and normalized issue digest. Guardedly save a creation record with that key and state `intent` before one create call; then save `created` with the exact task ID. Before any retry after a missing response, search and reconcile by the key. Reuse one unique matching task or pending record; an ambiguous or unreconciled intent stops without retry. The created todo task stays outside the run participant set and carries provenance, concrete reason, acceptance criterion, and routing rationale. Do not execute it. Report it in the supervisor recap.
3. **Replan.** The issue changes result, scope, material cost, risk, success, architecture, task meaning, route bounds, validation mode, or protected actions. Pause and supersede the run, then return to reviewed planning and required consent.

Every repair record states why it is not a replan. The task's adversarial review validates that classification. Misclassification, a repair bound breach, or recursive repair stops for replan. A migration number made stale by a newer `origin/main`, missing access dates in source metadata, or a verifier/CI defect is repaired automatically only when this predicate holds. For migrations, recheck the authoritative remote sequence immediately before opening the PR and again before human handoff.

## Human review and rejection

Human review, merge, migration application, deployment, publication, and acceptance are separate assigned tasks. A human gate never keeps its originating delivery task `in_progress`. Under gradual validation, the relevant branch waits at that task. Under final validation, keep preparing unrelated safe artifacts and stop only when no agent-owned frontier remains.

When a human rejects an artifact, append the external comments and event identity as evidence without changing task status, classify the correction, and guardedly save the repair intent first. Then transition a `waiting-human` run back to `active`, leave or mark the human task `blocked`, reopen the originating delivery task to `in_progress`, and create a subtask when the rule above requires one. Preserve the rejected artifact, its PASS records, and the rejection as immutable history. After correction and affected-surface review, mark the delivery task done again and move the same human task back to `todo`; never create a duplicate human review task. A later rejection repeats this loop within the repair bounds or triggers replan.

## External-event wakes

A supported GitHub event may wake a sleeping supervisor for CI completion, review submission, requested changes, merge, or another configured repository transition. GitHub documents the available webhook event types and payload fields in [Webhook events and payloads](https://docs.github.com/en/webhooks/webhook-events-and-payloads). Record provider, immutable event or delivery ID, repository, PR, head revision, action, mapped task or gate, and receipt time. Use provider plus event ID as the idempotency key. Ignore duplicates. Before any transition, reread the current PR and require its exact head revision to equal the event head. Persist stale or unmapped receipts as ignored ledger evidence but make no task-state transition.

An event may complete a human task only when it matches that task's saved wake predicate, exact owner or approval rule, required checks, head relation, and Done when evidence. Apply completion with the current Octopad guard. A verified normal approval, merge, migration-completion record, or other satisfied human task transitions a `waiting-human` run back to `active` before successor claims. A partial event updates evidence only and leaves the gate open.

A wake resumes reconciliation only. It never authorizes merge, migration application, deployment, publication, or another protected action. If native webhooks are unavailable, use bounded event-aware waiting rather than permanent polling; the supervisor may sleep and be resumed with the same event record.

## Fallback and terminal-session recovery

Use an executor fallback only when its exact route, trigger, proof clauses, bound, and evidence threshold of at least two observations were fingerprinted and consented. Durable evidence must meet that count and rule out prompt, context, access, environment, and verifier failures. Hidden reasoning, elapsed time, silence, or one unconfirmed finding is never capability evidence.

Before replacement, durably record failure and supersede the old attempt so late output cannot pass current checks. Start one fresh attempt and thread at the exact fallback route from the last valid immutable artifact when continuation is safe, or from the saved clean base otherwise. Never retarget a running thread or trust unpersisted work.

A current user instruction may authorize one replacement despite an unmatched trigger only when it names the task, exact already-saved route, and bound. Save the decision source, time, unresolved evidence, and consumed bound without claiming the trigger matched. Any unsaved route or material rewrite requires reviewed replanning and fresh consent.

For a conclusively dead executor or reviewer, apply only the contract's same-route Recovery bound or its saved task override. Supersede its attempt or reviewer record first. Before an artifact, restart a fresh attempt from the saved base. After a valid artifact, start a fresh recovery executor and the saved calibrated review from that revision. A dead independent reviewer replacement uses the same route and mandate; its predecessor PASS never transfers. A reviewer capability route change requires reviewed replanning and fresh consent.

## Plan changes

Before any saved plan change, guardedly pause and supersede the active run. Every changed fingerprint, including hygiene, requires the planning protocol's review, consent, and a new run ID. Old PASS and consent remain historical only.

## Resume and takeover

On `reprends le stream X`:

1. Start the correct Octopad session and call `build_context` for that stream.
2. Follow its coordination-ledger pointer, read the Plan manifest, then reread every participating tracker and verify the same pointer and hash.
3. Reconstruct the fingerprint; reread tasks, attempts, artifacts, reviews, gates, and saved thread IDs.
4. Select the expected target for the current owner mode: inline supervisor target for an inline owner, dedicated supervisor target for a dedicated owner. Reconcile it against `list_projects`, then verify the native thread's actual project and environment. A mismatch pauses without creating or steering a thread.
5. Inspect native state. Active, idle, not-loaded, or attention-needed means the saved supervisor still exists: send it one resume/reconcile message and create nothing.
6. Take over only after explicit relinquishment, an authoritative terminal non-resumable result, or a current user instruction to replace that parent. Silence or transient lookup failure is ambiguous.
7. Verify this recovery session's actual model, effort, target, and environment equal the saved inline route and inline supervisor target; otherwise stop and name the required route and target.
8. Guardedly claim the next epoch with a fresh inline owner token. If the update loses, reread and follow the winner.
9. Recover every uniquely identified active child without duplication.
10. Reapply the saved conditional policy. Remain inline when false or the dedicated-replacement bound is exhausted; otherwise bootstrap one dedicated parent.

An older parent that wakes after takeover fails its epoch check and stops. Do not revoke the whole run merely to replace its supervisor.

## Supervisor close

Executors and reviewers report to the supervisor; they do not send the stream's final user-facing message. When the run reaches verified completion or a genuine human-only frontier, the supervisor reconciles GitHub or other artifact systems, Octopad, the ledger, and native threads, then sends one recap containing:

- delivered artifacts and immutable revisions;
- required checks and adversarial review results;
- current human tasks and exact owners;
- problems encountered and how each was repaired or escalated;
- human rejection and correction loops;
- non-blocking follow-ups created;
- unresolved risks or branches;
- actual delivery tasks completed, repairs inserted, rejection loops, executor/reviewer/recovery sessions used, external-event wakes handled, and elapsed time to first artifact and to completion or gate.

Collect these actuals from existing ledger events. Do not estimate session counts in the brief, create a reporting task, launch a reporting session, or reread unchanged sources merely to produce statistics.

## Stops

Pause the affected branch with exact evidence on inactive or conflicting run state, missing contract, fingerprint mismatch, stale owner, stale attempt, ambiguous identity, unresolved lineage, unmatched fallback without a direct decision, exhausted bound, revision-mismatched review, material drift, or protected action. Stop the whole run only when the condition invalidates shared authority or no safe agent-owned frontier remains. A human gate is a whole-run stop only when every remaining branch waits on human action.

Thread creation that may have succeeded keeps its current nonterminal creation state through bounded native reconciliation. Ambiguity is a deliberate liveness stop: without native idempotency, automatic retry would risk duplicates.
