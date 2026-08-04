# Codex conditional supervision

Read this reference only after valid launch authority or when resuming. Octopad is authoritative for durable state; native Codex state is evidence about sessions.

## Contents

- [Contract gate and run states](#contract-gate-and-run-states)
- [Launch choice and ledger](#launch-choice-and-ledger)
- [Supervisor ownership](#supervisor-ownership)
- [Safe native-session creation](#safe-native-session-creation)
- [Reconciliation](#reconciliation)
- [Executor and reviewer protocol](#executor-and-reviewer-protocol)
- [Incidents and blockers](#incidents-and-blockers)
- [Adaptive repair and follow-up](#adaptive-repair-and-follow-up)
- [Human gates and wakes](#human-gates-and-wakes)
- [Recovery and plan change](#recovery-and-plan-change)
- [Accounting and portability](#accounting-and-portability)
- [Resume and close](#resume-and-close)

## Contract gate and run states

Before any write, claim, message, or native action, dispatch exactly one v5 supervision contract, one v2 fingerprint, and one canonical mandate through the contract. A hybrid, duplicate, changed, malformed, unknown, extra, or missing element stops fail closed and returns to replanning.

Run states are exactly `active`, `replanning`, `waiting-human`, `paused`, `revoked`, `superseded`, `failed`, and `completed`.

`active` authorizes only saved agent-owned claims and their required review. `replanning` authorizes no new delivery claim; already-claimed independent work plus the fresh planner and reviewer may continue. `waiting-human` authorizes only reconciliation while a human decision or gate is outstanding.

`paused` authorizes only safety reconciliation under its wake predicate. `revoked` authorizes no work after user or policy narrowing. `superseded` is the fenced historical run after cutover. `failed` is written only after independent proof of no authorized feasible route. `completed` is written only by the fenced supervisor after final validation and every required human occurrence is done.

Review verdicts remain distinct from these states; use the contract and planning meanings and never treat a review record as a run transition by itself.

Every transition is one guarded durable ledger write with the current concurrency guard. A failed guard grants no authority and causes a reread.

## Launch choice and ledger

Use inline supervision unless the saved policy requires a dedicated parent for at least four remaining delivery tasks, a complete saved parallel group, several streams, or an interruption/reconciliation burden that justifies the handoff.

A valid dedicated parent may finish a smaller remainder. Never create a reporting-only session. Apply the saved route ladder, target, environment, model, and effort exactly; an actual mismatch stops.

Before the first claim, reread the manifest, tracker pointers, graph, source revisions, verifier availability, feasibility digest, Plan review, saved-state equality, mandate, authority source, and current launch binding. Any mismatch stops before a session.

Guardedly append one fresh run record with a unique run ID, approved hash, authority mode, authority source, route, target, environment, owner token, supervisor epoch 1, replacement count, and state `active`. The plan hash must equal the manifest and live saved graph.

Only the current owner token and supervisor epoch may mutate the run. A takeover increments the epoch after proving the previous owner is fenced; late writes from an old epoch are rejected.

Apply the SKILL user-visible identifier rule to recaps. Internal prompts, ledger records, arguments, and creation records retain the full correlation identifiers.

## Supervisor ownership

Only the fenced supervisor claims tasks, creates successors, starts reviewers, records transitions, and sends the final user-facing recap. Executors, reviewers, parents, and children never relay or launch.

At each wake, reread the guarded cursor, run state, owner epoch, current plan hash, task attempt, artifact revision, gate, and relevant source evidence before a claim or write.

Continue every ready, safe, agent-owned branch. A human gate, open review, CI wait, merge, migration application, deployment, publication, or acceptance blocks only its branch unless no safe frontier remains.

At a fan-out, preflight every member, dependency, target, route, source, verifier, and authority. Activate a complete symmetric group in one guarded transition; never start a partial group.

At fan-in, wait for every dependency, record one integrated immutable revision, and make one guarded successor claim. Children and reviewers do not relay.

## Safe native-session creation

Every supervisor, executor, reviewer, recovery, and follow-up creation uses the contract's unique creation key and a durable creation record. Save `intent` before at most one native create call. At durable `intent`, `creator_owner_epoch` equals the then-current supervisor epoch and is immutable; a takeover monotonically increments the separate current supervisor epoch without changing identity.

The first prompt begins with the exact contract-defined `OCTOPLAN_CREATION` line, canonical creation token, and creator epoch; the visible title is human-readable and never replaces the identity. A malformed source title or target stops before creation.

Use the saved title patterns: `supervisor - <plain work stream name>`, `<plain work stream name> - #<N> <task name>`, `review - <plain work stream name> - #<N> <task name>`, and `specialist review - <plain work stream name> - #<N> <task name>`.

After a client, direct, empty, or missing response, call the native thread listing and inspect every current candidate. A client identifier is evidence only and is never passed as a native thread ID.

Read the candidate when needed and compare the complete immutable creation object, including creation key, token, creator epoch, route, target, environment, and artifact revision. Matching identity is separate from the current supervisor epoch: after the immutable comparison, gate the transition on that epoch. Zero matches remain `pending` while bounded reconciliation can still produce the event, then become `paused` after exhaustion; one exact match becomes `ready`; multiple or conflicting matches remain paused without retry.

Only an actor with `actor epoch == current supervisor epoch` may activate `ready` as `activated`, and every ledger transition requires the same equality. A create response never skips reconciliation. A crash or resume reconciles the existing intent and never makes a second create call.

Creation states are `intent`, `pending`, `ready`, `activated`, `failed`, and `paused`. Every nonterminal pause stores an evidence-based wake predicate.

## Reconciliation

Reconcile only the current run, owner epoch, plan hash, and relevant delta. Do not reread the whole plan unless a contract, authority, fingerprinted field, source revision, verifier, adoption map, or saved-state equality may have changed.

Before every claim, message, write, PASS, completion, or session creation, verify current state, attempt, route, target, environment, artifact revision, and authority. A mismatch stops without repair by inference.

Collect session, artifact, review, human-gate, and external-event evidence as immutable ledger records. A native session proves execution evidence only; it does not prove durable completion.

Recheck critical source revisions and verifier availability immediately before launch and after any relevant source or policy event. A changed value fences the affected branch.

Never let a human absence, a plausible title, or a caller-local path substitute for a durable owner, gate, target, or evidence record.

For a supported event wake, deduplicate by provider and immutable event ID, verify the current external head against the recorded head, and resume reconciliation only. GitHub is conditional; no provider assumption authorizes a protected action.

## Executor and reviewer protocol

The supervisor passes each executor the saved task, exact route and target, current attempt, source pointers, acceptance, proof, preconditions, and protected-action boundary. The executor may produce only the saved agent-owned artifact and evidence.

Before work and after every wake, an executor verifies its activated creation record, active state, owner epoch, approved hash, current task attempt, target, environment, and route. It stops on any mismatch.

Every artifact is immutable and revision-bound. A new artifact revision invalidates every PASS over that surface. A targeted reviewer may use deterministic checks in the current context; independent and specialist reviewers use fresh source-first sessions.

The lead reviewer validates the artifact against the saved task and Done when, records the exact review result, owns bounded correction, and marks the delivery task complete only after every required PASS. It never launches a successor. A specialist reports only to the lead.

A human task never becomes agent work through a route fallback. Protected occurrences use the contract's exact predicate and their owner/approval rule.

## Incidents and blockers

When an executor, reviewer, event, or preflight reveals a material incident, stop new claims on the affected path and record the contract's stable blocker key. Do not let rewording or an irrelevant artifact create a new identity.

Launch one fresh planner with no execution authority. It produces a concrete delta listing changed tasks, dependencies, routes, sources, verifiers, carried artifacts, invalidated evidence and PASS records, feasibility, and mandate comparison.

Run one fresh independent review of the delta, feasibility, source and verifier freshness, saved equality, conformance, human separation, and protected actions. A review proposal outside the specification returns to the parent rather than becoming a redesign.

Already-claimed demonstrably independent branches may finish under the old immutable plan; affected claims stop. No new old-plan claim is allowed during `replanning`.

## Adaptive repair and follow-up

The supervisor saves a repair comparison before any artifact, status, graph, or child-session write. A repair is valid only when result, scope, risk, acceptance, route bounds, envelope, and protected-action boundary are unchanged.

Use at most one active repair, two sequential repairs per parent, and depth one. Route it to the cheapest adequate saved executor, review the affected surface, preserve unrelated PASS records, and resume the parent only after the repair record closes.

A classification requiring judgment receives independent review before artifact work. A bound breach, recursive repair, changed fingerprinted field, or unknown predicate is a material replan.

A non-blocking follow-up is outside the participant set. Give it stable provenance, reason, acceptance, deduplication, and route evidence; never claim it or create a reporting-only session in this run.

## Human gates and wakes

Human review, merge, migration application, deployment, publication, access grant, spend, destructive effect, and acceptance are separate assigned occurrences. The mandate never authorizes one.

A human gate blocks its branch. Keep unrelated safe branches moving under `active` or `replanning` as permitted; use `waiting-human` when no safe progress remains or authority is unresolved.

When a human rejects an artifact, preserve the artifact, PASS records, and rejection evidence, classify the correction, save the repair intent, reopen the delivery task, and return the same human occurrence to its gate. Do not duplicate the gate.

An external wake supplies evidence, never authority. Stale, duplicate, unmapped, or head-mismatched events remain ignored evidence and cause no transition.

## Recovery and plan change

Use only the saved same-route recovery policy or task override. A dead session is fenced before a fresh attempt. Before an artifact, restart from the saved base; after an artifact, start a fresh recovery executor and the saved calibrated review. A predecessor PASS never transfers.

For an unsupported saved contract, quarantine schema-agnostically: do not parse, resume, message, or dispatch it. Poll or reconcile only under its evidence-based wake predicate. Prove every recorded native session terminal or quiescent, or explicitly adopt or reject its immutable artifact under the current contract. Ambiguity prevents new session creation; use `waiting-human` only when native reconciliation cannot resolve it safely.

For any material replacement, transition `active → replanning` and forbid new claims. Let already-claimed demonstrably independent children finish under the immutable plan; then common-fence every child and prove quiescence. Only after that barrier may canonical mutation, adoption, or supersession occur.

Under plan-bound, complete the full brief, review, equality, and consent path before the replacement run. Under outcome-bound, retain only the byte-identical mandate while the old run remains quiescent in `replanning`; persist and read back the adoption/rejection map and replacement draft, independently review both, and perform fresh feasibility, source/verifier, equality, v2 fingerprint, and conformance checks. Only then guardedly supersede the old run and bind/create the new `active` run.

The new run relaunches only unfinished work and requires a new hash, fresh equality, fresh feasibility, fresh adoption conformance, and fresh authority binding. The old launch binding, PASS records, and consent never transfer.

## Accounting and portability

Record only authoritative actuals with their source and canonical units. Null or unavailable means unavailable; never estimate provider cost. Compare a frozen numeric boundary mechanically only when the actual uses the same canonical units; otherwise obtain independent conformance judgment and use `HUMAN_DECISION`/`waiting-human` for authority-changing ambiguity.

Carry the stable blocker key across rewording and replacement runs. After two recurrences without new satisfiability evidence, reject the route and prove a materially different path or stop independently.

Apply the SKILL instruction-precedence and portability policy. Resolve owners from current roles, retrieve bounded context, keep Octopad and native Codex operations concrete, and use only conditional external adapters; local policy may narrow authority only.

## Resume and close

On resume, dispatch the contract, reread the current guarded ledger cursor, locate the owner epoch and creation records, reconcile native state, and create nothing while an exact existing supervisor can resume.

If no unique supervisor exists, use the saved creation key and one-call rule. If authority, target, hash, epoch, child identity, artifact lineage, or external state is ambiguous, pause with a concrete wake predicate.

The supervisor alone closes a run. It verifies final validation, every required human occurrence, all artifact revisions and review PASS records, unresolved risks, follow-ups, actuals, external wakes, and durable ledger state before writing `completed`.

The final recap reports delivered artifacts, checks and review results, remaining human work, repairs, rejections, blockers and resolutions, follow-ups, unresolved risks, and actual session/event counts without exposing opaque identifiers in visible prose.

Stop the affected branch on missing contract, hash mismatch, stale owner, stale attempt, ambiguous identity, unresolved lineage, exhausted bound, unavailable verifier, revision-mismatched review, material drift, or protected action. Stop the whole run only when shared authority is invalid or no safe agent-owned frontier remains.
