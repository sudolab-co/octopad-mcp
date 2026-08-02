# Codex conditional supervision

Read this file only after clear execution consent or a request to resume a run. Octopad is authoritative; native Codex state is evidence about sessions only.

A missing `octoplan-supervision-v1` contract stops before any native execution action. Replan from current Octopad state. Before a new run, inventory legacy threads and artifacts; every live legacy owner must be conclusively stopped or its immutable result explicitly adopted into the new lineage. Never create a v3 attempt while an ambiguous legacy executor may still own the same task.

## Choose the current mode

Apply the saved `octoplan-supervision-v1` policy at launch or after a necessary takeover. Use a dedicated supervisor when any saved predicate is true:

- at least four delivery tasks remain, excluding final validation and normally requiring at least eight executor/reviewer completion wakes;
- parallel fan-out or fan-in remains;
- multiple streams share the run;
- at least two tasks remain across a human, external, or explicit interruption gate.

Otherwise supervise inline. An existing valid dedicated parent may finish a smaller remainder. Goal mode is optional only when the user explicitly requested it; it never proves approval, ownership, state, or completion.

## Contract and ledger

Use comments on the saved coordination-ledger task. For one stream this is its final-validation task; every tracker in a multi-stream run must point to the same immutable task ID.

Planning already saved one Plan manifest containing participant IDs, policy, routes, defaults, review routes, and the reviewed SHA-256. Task and tracker content remains at source. Reconstruct it by the planning reference's Fingerprint rules. Missing pointers, fields, matching plan-review PASS, or hashes stop.

After consent and before any claim, verify this session's actual model and effort equal the saved inline route. Then guardedly append the first run record: unique run ID, exact approved hash, approval source thread and time, state `active`, current mode and route, fresh inline owner token, supervisor epoch 1, zero dedicated replacements used, and no candidate. The approved hash must still equal the manifest and live plan.

Append every ledger transition with `tasks(action: "update")` and the current `expected_updated_at`. The latest successfully guarded comment wins; a failed update grants no authority. Run states are `active`, `paused`, `failed`, `superseded`, `revoked`, and `completed`. Only `active` authorizes work. Only the fenced supervisor may write `completed`, after the final-validation task is durably done and the integrated result satisfies the definition of success.

## Supervisor ownership

Every inline or dedicated supervisor has a unique owner token and monotonically increasing supervisor epoch. The latest owner entry also stores current mode and route plus dedicated thread and host IDs when applicable.

Before every claim, creation, steering action, run transition, successor launch, and after every wake:

1. reread the ledger and reconstruct the fingerprint;
2. verify the run is active;
3. verify this owner token and supervisor epoch match the latest entry;
4. for a dedicated parent, verify its exact thread and host IDs;
5. stop without side effects on any mismatch.

Epoch changes fence supervisors only. Child authority remains bound to run ID, fingerprint, task claim, and attempt ID.

## Safe thread creation

Every supervisor, executor, reviewer, and recovery creation uses one durable creation record keyed by run, task or candidate, attempt, role, route, and artifact revision when applicable. Guardedly save a unique token and `intent` before calling `create_thread` once. Start the native title and prompt with that full key and token; require no work until the exact record is `activated`. Save `pending` only with a returned `clientThreadId`, `ready` only with real thread and host IDs, `activated` after supervisor transfer or a guarded child start, and `failed` only after authoritative terminal failure and no unique native match.

Never pass a client ID to thread tools. Resolve it through one unique match in `list_threads`. A lost result stays `intent`; reconcile by the full key and never retry while creation is ambiguous.

## Bootstrap a dedicated parent

The planning or recovery session remains inline owner until transfer finishes.

1. Use Safe thread creation with the candidate token as identity. Start its title and prompt with run ID, token, supervisor role, and route; do not embed a proposed epoch.
2. Tell it to create nothing until the ledger names its token and real IDs; before activation it returns only `awaiting activation: <token>`.
3. The inline owner guardedly transfers ownership at its current epoch plus one, saves the real IDs, and marks `activated`.
4. Send one activation/reconcile message. The parent rereads the ledger before acting.

If the bootstrap owner disappears, recovery takes a newer inline epoch while preserving the candidate record, then uniquely recovers and activates it at the next epoch. Relaunch only after authoritative native state proves failure and no matching thread exists. Every candidate after the first consumes the saved dedicated-replacement bound, whether its predecessor failed before or after activation and regardless of takeover cause. A resume or replacement request does not add a candidate; when the bound is exhausted, continue inline.

## Reconciliation loop

The fenced supervisor repeats this loop from durable state, not conversation memory:

1. Reread every participating tracker, task, dependency, attempt, artifact, review, gate, and saved thread record.
2. Recompute the active fingerprint and verify ownership.
3. Inspect saved native threads. Recover only unique matches.
4. Resolve the ready frontier from dependencies; `Next` and rank are explanations only.
5. Require exactly one ready task or one complete saved symmetric parallel group. Otherwise stop for an unserialized frontier. Also stop at human gates, placeholders, unmet preconditions, foreign assignments, missing routes, plan drift, or protected actions.
6. Preflight that task or group. Claim each task with current `expected_updated_at`; if a group claim fails, release every unlaunched claim acquired by this owner, reread, and create nothing from the failed set.
7. Persist an attempt ID `<task ID>@<claimed updated_at>` plus exact immutable base revision and lineage resolved from the contract default or saved override.
8. Use `list_projects`; create a fresh worktree for Git and the saved local project otherwise. Use Safe thread creation at the exact saved route.
9. Monitor with `wait_threads` and current cursors. Use `send_message_to_thread` only for a concrete blocker, correction, activation, or resume. Treat every child message as a wake signal and reread Octopad before transition.

At fan-out, create every member but keep all records at `ready` until the complete group has real IDs. Then activate the whole group in one guarded transition. An unresolved member activates none. At fan-in, wait for durable completion of every dependency and save one explicit integrated revision before the successor or final validation.

## Executor and review prompts

Start every executor prompt with creation token, task ID, run ID, attempt ID, role, route, and base revision. Require it to do no work until its creation record is `activated`, call Octopad `build_context`, and reread exact sources. Before work, after every wake, and before artifact writes, it verifies the active run, fingerprint, current attempt, route, and base; a mismatch stops without writes.

The executor produces and verifies one durable artifact, saves one unambiguous current immutable artifact revision, then uses Safe thread creation for the saved fresh lead and any `Specialist review route`. It implements lead corrections but never marks the task done or launches a successor.

Before work, after every wake, and before any write, PASS, or completion, each reviewer verifies its activated creation record, the active run, fingerprint, current attempt and review record, mandate, and exact artifact revision. A mismatch stops without writes. Each reviewer opens that revision independently. A specialist reports only to the lead and never completes or relays. The lead coordinates corrections, requires every saved reviewer PASS on the same current revision, verifies `Done when`, marks the task done with the current guard, and never launches a successor. A new artifact revision invalidates every earlier PASS.

Only the supervisor rereads durable completion, checks that no result invalidated a future assumption, dependency, integration base, or success definition, and then claims successors.

## Fallback and terminal-session recovery

Use an executor fallback only when its exact route, trigger, proof clauses, bound, and evidence threshold of at least two observations were fingerprinted and consented. Durable evidence must meet that count and rule out prompt, context, access, environment, and verifier failures. Hidden reasoning, elapsed time, silence, or one unconfirmed finding is never capability evidence.

Before replacement, durably record failure and supersede the old attempt so late output cannot pass current checks. Start one fresh attempt and thread at the exact fallback route from the last valid immutable artifact when continuation is safe, or from the saved clean base otherwise. Never retarget a running thread or trust unpersisted work.

A current user instruction may authorize one replacement despite an unmatched trigger only when it names the task, exact already-saved route, and bound. Save the decision source, time, unresolved evidence, and consumed bound without claiming the trigger matched. Any unsaved route or material rewrite requires reviewed replanning and fresh consent.

For a conclusively dead executor or reviewer, apply only the contract's same-route Recovery bound or its saved task override. Supersede its attempt or reviewer record first. Before an artifact, restart a fresh attempt from the saved base. After a valid artifact, start a fresh recovery executor and full reviewer set from that revision. A dead reviewer replacement uses the same route and mandate; its predecessor PASS never transfers. A reviewer capability route change requires reviewed replanning and fresh consent.

## Plan changes

Before any saved plan change, guardedly pause and supersede the active run. Every changed fingerprint, including hygiene, requires the planning protocol's review, consent, and a new run ID. Old PASS and consent remain historical only.

## Resume and takeover

On `reprends le stream X`:

1. Start the correct Octopad session and call `build_context` for that stream.
2. Follow its coordination-ledger pointer, read the Plan manifest, then reread every participating tracker and verify the same pointer and hash.
3. Reconstruct the fingerprint; reread tasks, attempts, artifacts, reviews, gates, and saved thread IDs.
4. Inspect native state. Active, idle, not-loaded, or attention-needed means the saved supervisor still exists: send it one resume/reconcile message and create nothing.
5. Take over only after explicit relinquishment, an authoritative terminal non-resumable result, or a current user instruction to replace that parent. Silence or transient lookup failure is ambiguous.
6. Verify this recovery session's actual model and effort equal the saved inline route; otherwise stop and name the required route.
7. Guardedly claim the next epoch with a fresh inline owner token. If the update loses, reread and follow the winner.
8. Recover every uniquely identified active child without duplication.
9. Reapply the saved conditional policy. Remain inline when false or the dedicated-replacement bound is exhausted; otherwise bootstrap one dedicated parent.

An older parent that wakes after takeover fails its epoch check and stops. Do not revoke the whole run merely to replace its supervisor.

## Stops

Pause with exact evidence on inactive or conflicting run state, missing contract, fingerprint mismatch, stale owner, stale attempt, ambiguous identity, unresolved lineage, unmatched fallback without a direct decision, exhausted bound, revision-mismatched review, material drift, protected action, or human gate.

Thread creation that may have succeeded keeps its current nonterminal creation state through bounded native reconciliation. Ambiguity is a deliberate liveness stop: without native idempotency, automatic retry would risk duplicates.
