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

Before routing, consent, or a native session, dispatch exactly one v5 supervision contract, one v2 fingerprint, and one canonical mandate through the contract rules. A hybrid, duplicate, changed, malformed, unknown, extra, or missing element stops before any write or launch.

Planning permission never authorizes execution. On the default path, the mandatory brief is the whole initial reply and a later reply must confirm the complete brief before normal planning writes; the contract's explicit-no-loop path is the non-blocking checkpoint exception.

Use **Review before delivery** and **Autonomous delivery** in user-visible prose; their internal wire values remain contract-only. Review before delivery accepts brief confirmation followed by later exact-final-hash consent, or a confirmed brief plus explicit automatic-launch authority. Autonomous delivery requires unambiguous end-to-end delegation inside the confirmed envelope, except for the contract's valid first-message activation.

A single natural-language instruction may grant autonomous delivery without enumerating internal permissions when it clearly delegates finding, executing, and adapting the plan for a bounded outcome. A bare confirmation, urgency, vague autonomy, prior conversation, or permission to plan is not execution authority. A later exact-hash yes cannot repair a missing grant.

## Shared capacity ladder

Use this one ladder for executors, reviewers, recovery, and supervisor calibration. Review class remains separate from capacity selection; save the exact model, effort, target, environment, and rationale.

| Observable detection profile | Route |
|---|---|
| Exact mechanical work with deterministic proof | `gpt-5.6-luna · effort high` |
| Routine bounded work with strong proof | `gpt-5.6-luna · effort xhigh` |
| Difficult bounded work with strong proof | `gpt-5.6-luna · effort max` |
| Everyday interpretation, tone, or editorial work | `gpt-5.6-terra · effort high` |
| Bounded product, analysis, communication, or editorial judgment | `gpt-5.6-terra · effort xhigh` |
| Difficult bounded judgment beyond Luna without open ambiguity | `gpt-5.6-terra · effort max` |
| Open-ended work or weak verification | `gpt-5.6-sol · effort high` |
| High-consequence work hard to detect or reverse | `gpt-5.6-sol · effort xhigh` |
| Open architecture or investigation without a reliable verifier | `gpt-5.6-sol · effort max` |

Risk labels alone never select Sol. A Sol rationale states why Luna and Terra are inadequate. Split separable work before raising capacity; never silently substitute a saved route. `ultra` means genuinely independent parallel delegation with user opt-in, not difficulty.

Planning uses Sol `xhigh`, or justified `max`. A dedicated supervisor uses Terra `xhigh` by default, Terra `max` for difficult bounded reconciliation, and Sol only for orchestration ambiguity, weak verification, or costly irreversibility.

## Failure diagnosis

Missing or contradictory context returns to a fresh Sol planning pass. Environment, access, or verifier failure repairs the blocker without changing capacity. A confirmed capability miss on a sound task uses only its saved fallback; it does not walk the ladder.

Before consent, a fallback records the exact route, failed criterion, maximum replacements, at least two repeated observations, and observations establishing prompt, context, access, environment, and verifier soundness. A direct user exception names the task, saved route, and bound; it does not prove the stored trigger.

A material result, scope, cost, risk, success, architecture, task meaning, route bound, validation, or protected-action change stops the run for replan. A failed reviewer returns to the saved review path or asks for fresh consent; it never relays a successor.

## Review routing

Every delivery task receives an adversarial check. `targeted` is deterministic, interaction-free proof in the current context; `independent` is one fresh source-first reviewer; `specialist` adds one fresh reviewer only for a second orthogonal material failure domain. A specialist never completes or relays.

Choose a review route from the shared ladder by detection difficulty, not executor prestige. Plan review uses a fresh delegated reviewer, never a user-owned thread. The lead owns correction and PASS but never launches a successor.

## Consent and launch binding

Without valid advance authority, ask: “The plan is complete and verified. Do you authorize Codex to execute this exact plan now?” Then stop; do not create or monitor an executor while waiting.

With valid advance authority, repeat brief conformance, source and verifier freshness, feasibility, saved-state equality, mandate conformance, and review PASS after the final review.

Append the contract-defined launch binding as one guarded coordination-ledger record using the current concurrency guard; it never enters the manifest or fingerprint.

A material replan invalidates the old launch binding in either mode but does not invalidate a byte-identical outcome-bound mandate. The replacement needs fresh feasibility, adoption map, read-back equality, v2 fingerprint, and independent conformance PASS. No PASS or consent transfers.

## Authority scope and accounting

Valid authority covers only the reviewed hash, saved conditional policy, saved routes and targets, bounded recovery and repair, saved fallbacks, agent-owned executor/reviewer sessions, non-blocking follow-ups, reconciliation wakes, and still-valid parallel groups.

It never covers a human-only task, an unsaved route, an out-of-envelope replan, a protected action, a new audience or access grant, or a model/effort/target substitution. Apply the contract's exact protected human-occurrence predicate; the mandate never satisfies it.

Record authoritative actuals only. Unavailable time or provider cost remains null/unavailable; never estimate cost. Compare numeric boundaries mechanically only when frozen and actual values use the same canonical units. Otherwise request fresh independent mandate conformance; authority-changing ambiguity is `HUMAN_DECISION` and `waiting-human`.

## Target and route binding

Every executor, reviewer, recovery, and supervisor uses its saved route, target, environment, model, and effort. Resolve the target through current runtime capabilities; an unresolved or changed binding stops before creation.

Keep external-event adapters conditional and use native Codex operations for native sessions. A wake supplies evidence only and cannot expand the saved route or authority.

After valid authority, read [codex-supervision.md](codex-supervision.md) completely before creating or resuming any native session.
