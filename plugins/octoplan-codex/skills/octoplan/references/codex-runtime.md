# Codex routing and execution consent

Read this reference before routing or asking for execution consent. Read the contract with it; schemas, exact fields, bytes, and protected-occurrence shape live only there.

## Contents

- [Contract and authority gate](#contract-and-authority-gate)
- [Shared capacity ladder](#shared-capacity-ladder)
- [Failure diagnosis](#failure-diagnosis)
- [Review routing](#review-routing)
- [Consent and launch binding](#consent-and-launch-binding)
- [Authority scope and accounting](#authority-scope-and-accounting)
- [Target and route binding](#target-and-route-binding)

## Contract and authority gate

Before routing, consent, or a native session, dispatch exactly one v6 supervision contract, one v3 fingerprint, and one canonical mandate through the contract rules. A hybrid, duplicate, changed, malformed, unknown, extra, or missing element stops before any write or launch.

Planning permission never authorizes execution. On the default path, the mandatory brief is the whole initial reply and a later reply must confirm the complete brief before normal planning writes; the contract's explicit-no-loop path is the non-blocking checkpoint exception.

Use **Review before delivery** and **Autonomous delivery** in user-visible prose; their internal wire values remain contract-only. Review before delivery accepts brief confirmation followed by later exact-final-hash consent, or a confirmed brief plus explicit automatic-launch authority. Autonomous delivery requires unambiguous end-to-end delegation inside the confirmed envelope, except for the contract's valid first-message activation.

A single natural-language instruction may grant autonomous delivery without enumerating internal permissions when it clearly delegates finding, executing, and adapting the plan for a bounded outcome. A bare confirmation, urgency, vague autonomy, prior conversation, or permission to plan is not execution authority. A later exact-hash yes cannot repair a missing grant.

## Shared capacity ladder

Use this one ladder for executors, reviewers, recovery, and supervisor calibration. Review class remains separate from capacity selection; save the exact model, effort, target, environment, and rationale.

| Observable detection profile | Route |
|---|---|
| Exact mechanical work with deterministic proof | `gpt-5.6-luna · effort max` |
| Routine bounded work with strong proof | `gpt-5.6-luna · effort max` |
| Difficult bounded work with strong proof | `gpt-5.6-luna · effort max` |
| Everyday interpretation, tone, or editorial work | `gpt-5.6-terra · effort high` |
| Bounded product, analysis, communication, or editorial judgment | `gpt-5.6-terra · effort xhigh` |
| Difficult bounded judgment beyond Luna without open ambiguity | `gpt-5.6-terra · effort max` |
| Open-ended work or weak verification | `gpt-5.6-sol · effort high` |
| High-consequence work hard to detect or reverse | `gpt-5.6-sol · effort xhigh` |
| Open architecture or investigation without a reliable verifier | `gpt-5.6-sol · effort max` |

Risk labels never select Sol; split separable work, never silently substitute a saved route, and reserve `ultra` for explicit parallel user opt-in. Automatic routing canonicalizes model/effort before selection, saving, or creation. The minimum automatic capacity is exactly `gpt-5.6-luna · effort max`; reject unknown pairs, Luna `high`/`xhigh`, and every route below it. Terra/Sol need existing rationale; `least costly` means the cheapest normalized candidate at or above the floor.

Planning uses Sol `xhigh`, or justified `max`. A dedicated supervisor uses Terra `xhigh` by default, Terra `max` for difficult bounded reconciliation, and Sol only for orchestration ambiguity, weak verification, or costly irreversibility. A bounded incident-reasoning delegate uses the least costly normalized model/effort pair at or above the Luna max floor that can detect the issue; raise capacity only when the incident's detection difficulty warrants it, and record the rationale.

## Failure diagnosis

Missing context, a missing skill, a missing capability, environment or access failure, and verifier failure are incidents owned by the supervisor. The supervisor diagnoses the issue, keeps safe work moving, and seeks a compliant path inside the saved scope, policy, mandate, human gates, and protected-action boundary. When useful, it delegates bounded reasoning to a fresh planner or recovery actor with model and effort suited to the incident; that actor returns a proposal only, and the supervisor decides and records the path.

A child does not turn its own limitation into a new stop condition or user request. A planner cannot be created until its `capacity_source` record is read and its digest is verified. The user is contacted only after the supervisor has evidence that no solution respecting the guardrails exists; a missing skill or tool alone is not that proof.

Before consent, a fallback records the exact route, failed criterion, maximum replacements, at least two repeated observations, and observations establishing prompt, context, access, environment, and verifier soundness. A direct user exception names the task, saved route, and bound; it does not prove the stored trigger.

A material result, scope, cost, risk, success, architecture, task meaning, route bound, validation, or protected-action change stops the run for replan. A failed reviewer returns to the saved review path or asks for fresh consent; it never relays a successor.

## Review routing

Every delivery task receives an adversarial check. `targeted` is deterministic, interaction-free proof in the current context; `independent` is one fresh source-first reviewer; `specialist` adds one fresh reviewer only for a second orthogonal material failure domain. A specialist never completes or relays.

Choose a review route from the shared ladder by detection difficulty, not executor prestige. Plan review uses a fresh delegated reviewer, never a user-owned thread. The lead owns correction and PASS but never launches a successor.

## Consent and launch binding

Without valid advance authority, ask: “The plan is complete and verified. Do you authorize Codex to execute this exact plan now?” Then stop; do not create or monitor an executor while waiting.

With valid advance authority, repeat brief conformance, source and verifier freshness, feasibility, saved-state equality, mandate conformance, and review PASS after the final review.

Append the contract-defined launch binding as one guarded coordination-ledger record using the current concurrency guard; it never enters the manifest or fingerprint.

A material replan invalidates the old launch binding in either mode but does not invalidate a byte-identical outcome-bound mandate. The replacement needs fresh feasibility, adoption map, read-back equality, v3 fingerprint, and independent conformance PASS. No PASS or consent transfers.

## Authority scope and accounting

Valid authority covers only the reviewed hash, saved conditional policy, saved routes and targets, bounded recovery and repair, saved fallbacks, agent-owned executor/reviewer sessions, bounded incident reasoning, non-blocking follow-ups, reconciliation wakes, and still-valid parallel groups.

It never covers a human-only task, an unsaved route, an out-of-envelope replan, a protected action, a new audience or access grant, or an arbitrary model/effort/target substitution. A capacity choice explicitly allowed by the saved incident policy is not an arbitrary substitution; otherwise save and review the delta before acting. Apply the contract's exact protected human-occurrence predicate; the mandate never satisfies it.

Record authoritative actuals only. Unavailable time or provider cost remains null/unavailable; never estimate cost. Compare numeric boundaries mechanically only when frozen and actual values use the same canonical units. Otherwise request fresh independent mandate conformance; authority-changing ambiguity is `HUMAN_DECISION` and `waiting-human`.

## Target and route binding

Every executor, reviewer, recovery, follow-up, and supervisor uses its saved route, target, environment, model, and effort. A planner role uses the saved incident route and its recorded capacity rationale. Every target must have the same Codex project identity as the planning target: project targets keep the exact `project_id`, while projectless targets keep the exact `directory_name`; `local` and `worktree` may differ only inside the same project. Resolve the target through current runtime capabilities and role capability topology; an unresolved, cross-project, project/projectless, or changed binding stops before creation.

An analytical delegate, including a `multi_agent` delegate, is not a native supervisor, reviewer, or successor launcher. It may return a bounded proposal to the fenced supervisor, but it cannot claim a delivery task, record a PASS, create a native child, or relay a result.

Keep external-event adapters conditional and use native Codex operations for native sessions. A wake supplies evidence only and cannot expand the saved route or authority.

After valid authority, read [codex-supervision.md](codex-supervision.md) completely before creating or resuming any native session.
