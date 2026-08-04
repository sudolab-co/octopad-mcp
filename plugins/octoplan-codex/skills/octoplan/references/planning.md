# Octoplan planning protocol

The dependency graph is executable truth. This reference owns planning workflow, review meanings, feasibility reasoning, and repair classification; exact saved shapes and bytes live only in [octoplan-contract-v3.md](octoplan-contract-v3.md).

## Contents

- [Entry gate](#entry-gate)
- [Context and scoping brief](#context-and-scoping-brief)
- [Workflow](#workflow)
- [Decisions and graph](#decisions-and-graph)
- [Feasibility](#feasibility)
- [Plan review](#plan-review)
- [Consent binding](#consent-binding)
- [Parallel work and Blueprints](#parallel-work-and-blueprints)
- [Runtime classification](#runtime-classification)
- [Blockers and accounting](#blockers-and-accounting)
- [Saved-state self-check](#saved-state-self-check)

## Entry gate

Read this reference completely for a planning, replanning, or flesh-out pass.

As soon as the scoping brief is complete, read the contract completely before review, feasibility, any draft persistence, fingerprinting, or consent.

Dispatch the complete saved pair before reading saved authority: exactly one v6 supervision contract, one v3 fingerprint, and one canonical mandate are required.

Any absent, duplicate, hybrid, changed, malformed, unknown, extra, or missing contract element fails closed before a write or native session.

Do not infer fields, authority, review PASS, feasibility PASS, adoption, consent, or a target from prose or caller context.

## Context and scoping brief

Retrieve only bounded, decision-relevant context and authoritative source pointers needed to prove the graph; do not turn generic tool parameters or an unbounded workspace dump into evidence.

Read the stream's governing Decisions, Questions, tasks, graph edges, tracker, and required source records. Resolve people from current members and roles.

Ask only questions that can change result, scope, risk, order, proof, owner, or validation timing.

On the default path, the first reply on every full pass is the whole scoping brief: Understanding; In scope / out of scope including the nearest excluded result; Success; Assumptions with verified basis; Open questions; Validation mode, either `gradual` or `final`; Delivery mode; and a one-line authority summary.

On the default path, do not write a plan or create an execution session before the later confirmation; valid explicit-no-loop instead publishes a non-blocking checkpoint and may continue planning under the exact initial grant.

Use the user-facing labels from the contract. Default to **Review before delivery**. An initial **Autonomous delivery** request, or semantically equivalent end-to-end delegation in any language, may activate the contract's explicit-no-loop path when the instruction unambiguously covers finding the plan, executing it, and adapting it inside a complete outcome envelope.

A later brief-only confirmation grants no execution authority. A bare “do it”, urgency, trust without delivery delegation, prior conversation, or permission to plan never supplies the missing grant.

The explicit no-loop path is valid only when the initial request already contains that explicit grant, a complete outcome envelope, no unresolved material point, no scope-expanding inference, and separate protected occurrences.

For that path, publish the brief as a non-blocking checkpoint, record the exact source, and continue through durable Decision persistence. Once durable Decision IDs make the complete canonical mandate available, obtain a fresh independent activation review before Plan PASS, fingerprinting, consent, or launch; no execution session precedes it.

If a material answer remains open after one further question, save a Question and leave affected tasks as flesh-out placeholders.

## Workflow

1. **Review or discover.** Establish the current stream, its source claims, definition of success, owners, gates, and graph. Separate facts, Decisions, Questions, and assumptions.
2. **Reflect or branch.** On the default path, return the complete brief and wait for the later user reply; apply corrections only after it and do not save partial planning artifacts. On valid explicit-no-loop, publish the non-blocking checkpoint and continue planning under the exact initial grant.
3. **Lock choices.** Present each material choice as decision, options with gain and cost, recommendation, and reversibility. Save only accepted choices as authoritative Decisions.
4. **Ground and preflight.** Resolve the planning session's active Codex target, save it as the inline supervisor target, and verify that every supervisor, executor, reviewer, recovery, and follow-up target has the same Codex project identity. Then verify governing documents, repository patterns, access, source revisions, rollback or compensation, exact verifiers, verification actions or commands, and policy gates.
5. **Draft off-record.** Give each task a stable symbolic key, a single coherent job, dependencies, owner, route, acceptance, proof, repair envelope, and human gates before assigning durable IDs.
6. **Build feasibility.** Scan every agent and human task against every trigger class in the contract. Map each triggered invariant to one row and each row back to one task/invariant pair.
7. **Simulate readiness.** Walk the first ready frontier and the highest-risk path. Add a prerequisite, narrow a promise, or return a material choice when the path is not executable now.
8. **Review the draft.** Use one fresh independent reviewer by default. Add a specialist only for a genuinely orthogonal material failure domain.
9. **Read back.** Persist only the complete final graph using the current concurrency guard, reread it, normalize immutable IDs to the symbolic draft, and set saved-state equality to PASS only on exact equality.
10. **Fingerprint and bind.** Recheck source revisions and verifier availability, compute the contract's v3 bytes, obtain independent mandate conformance, and bind the reviewed plan hash only after every required PASS.
11. **Resolve consent.** Follow the exact plan-bound or outcome-bound path in runtime. A failed guarded binding writes no authority and returns to consent or waiting.

## Decisions and graph

Every material result, scope edge, success condition, risk boundary, validation choice, owner rule, and route bound is an authoritative Decision or Question, never an assumption hidden in task prose.

Every saved task uses the contract's direct task shape. Its description contains literal Why and What; every top-level task also contains literal Done when, impact from 1 through 5, and an impact rationale.

Subtasks use a parent task only as a concrete in-session checklist. A dependency edge carries its one-line rationale. One task equals one focused executor session.

Delivery tasks end at a review-ready agent artifact. Human review, merge, migration application, deployment, publication, access grant, external spend, destructive effect, and acceptance are separate human occurrences.

Save exact execution and review routes, fallback evidence and bounds, same-project target choices, and verification actions or commands needed by a fresh executor. Never rely on the planning conversation.

Save the plan manifest, tracker pointer, graph, source revisions, feasibility proof, review record, mandate, and binding through guarded durable writes; a failed concurrency check has no effect.

Keep tracker and Blueprint logic-only. A Blueprint may summarize outcome, stream roles, order, parallel branches, gates, finish condition, and ledger reference, but not statuses or copied task content.

## Feasibility

For each triggered invariant, require an available primitive, authoritative source revision, consistency boundary, rollback or compensation, exact verifier with current availability, and prerequisite.

Missing primitive, stale or missing source, unavailable verifier, unresolved boundary, or missing prerequisite produces `REVISE`, `INFEASIBLE`, or `HUMAN_DECISION`; it cannot produce prose PASS.

An empty matrix can PASS only when every task coverage record has an empty `triggered_invariants`. Do not omit an atomicity or concurrency row merely because a task uses several local operations.

Bind the matrix digest to Plan review, critical source revisions, and verifier availability. Recheck all three immediately before launch and after a relevant source change.

Plan review must verify completeness, memory-less execution, graph feasibility, every matrix row, current sources and verifiers, mandate conformance, human/agent separation, repair bounds, protected-action separation, and brief conformance.

## Plan review

`PASS` means the draft is complete, feasible, current, mandate-conformant, and equal to saved state.

`REVISE` means a concrete design, evidence, source, route, or prerequisite correction can make the plan pass.

`INFEASIBLE` means an independent reviewer proves that the authorized route cannot satisfy an invariant; the affected frontier is blocked.

`HUMAN_DECISION` means authority, policy, protected action, unresolved choice, or an unavailable safe path requires a human decision.

Persist the lead route, optional orthogonal specialist route, exact reviewer PASS, reviewed draft digest, matrix digest, source/verifier result, mandate-conformance result, and saved-state equality in the contract-defined Plan review.

A changed semantic field, source revision, verifier, matrix, mandate, adoption row, conformance result, or equality result requires a fresh review. Never carry a prior PASS by similarity.

## Consent binding

`plan-bound` uses either brief-only confirmation followed by later exact-final-hash consent, or a confirmed brief plus explicit advance-launch authority when the reply grants automatic launch after verification.

`outcome-bound` uses a confirmed brief plus explicit plan, launch, and material-replan authority, or the contract's explicit no-loop path. Its mandate remains byte-identical across eligible replans; its old launch binding does not.

Before automatic launch, append the contract-defined guarded ledger binding with its current concurrency guard. Keep this runtime evidence outside the manifest fingerprint.

A material replan invalidates the old launch binding in either mode. The replacement needs fresh feasibility, adoption mapping, source/read-back equality, v3 fingerprint, and independent conformance PASS before a new run; no old PASS or consent transfers.

## Parallel work and Blueprints

Parallelism is exceptional. Every member must share the same readiness frontier and no file, symbol, contract, artifact, editorial structure, migration, lockfile, or scarce resource.

After all tasks exist, persist symmetric parallel-safety relations using immutable IDs. The supervisor claims and activates the complete group in one guarded transition.

Multi-stream work starts with an effort brief exposing seams and ownership, then each stream receives its own confirmed stream-level brief. Wire cross-stream dependencies in the graph.

The Blueprint explains coordination only; the graph, Decisions, Questions, tasks, and human occurrences enforce it.

## Runtime classification

Classify every discovery against the confirmed brief and affected task before any artifact, status, graph, or child-session write.

Repair stays within one task's result, scope, risk, acceptance, route bounds, repair envelope, and protected-action boundary. Save the comparison first, use the cheapest adequate saved route, review the affected surface, and resume the parent.

Allow at most one active repair, two sequential repairs per parent, and depth one. A bound breach or judgmental classification requires a reviewed replan.

Follow-up is useful but non-blocking work outside the active participant set. Record provenance, reason, acceptance, deduplication, and route rationale; do not execute it in the current run.

Replan when result, scope, material cost, risk, success, architecture, task meaning, route bound, validation mode, or protected action changes. Under outcome-bound, an in-envelope replan uses an internal delta and no new user-facing gate; outside-envelope or ambiguous changes ask the user.

## Blockers and accounting

Persist the contract's stable blocker key and reason enum before changing a route. Rewording, replacement runs, or irrelevant artifacts do not create a new identity or reset recurrence.

After two recurrences without new satisfiability evidence, reject the failed route and prove a materially different route, or produce `HUMAN_DECISION`, `waiting-human`, `paused`, or independently confirmed `INFEASIBLE`.

Record authoritative actuals only. Use null or unavailable for missing time or provider cost; never estimate provider cost.

Compare numeric bounds mechanically only when frozen boundary and authoritative actual share canonical units. Otherwise use fresh independent mandate-conformance judgment; authority-changing ambiguity is `HUMAN_DECISION` and `waiting-human`.

## Saved-state self-check

Before Plan PASS, confirm the brief and validation mode, every material Decision, every Question gate, every real dependency, target resolution, task shape, one-job size, exact routes, review class, verification, preconditions, human separation, and next frontier.

Confirm every delivery task has an adversarial review target: targeted for deterministic interaction-free proof, independent for normal artifact review, specialist only for the orthogonal exception.

Confirm the first agent-owned task is executable from current access, all critical source revisions and verifiers are current, every matrix row is present, and no known prerequisite is delegated to a future repair.

Confirm all trackers carry the contract pointer and one plan hash, the manifest has one complete contract-defined record, and Blueprint content is not authoritative.

Confirm the canonical input includes every contract-required field, excludes only named runtime/generated records, normalizes both final-hash fields to `PENDING`, and preserves every unlisted sequence.

Confirm the launch binding refers to the current hash and review evidence, protected occurrences remain separate, and every replacement has a reviewed adoption map and fresh conformance PASS.
