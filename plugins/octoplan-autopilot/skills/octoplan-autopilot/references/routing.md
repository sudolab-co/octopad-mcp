# Routing — Exec and Review lines in full

Load this before writing any task's Exec or Review line, and whenever a saved route's availability, enforcement, or effort vocabulary is in question. The core rules (floor, no substitution, review defaults) are in SKILL.md; this file carries the detail.

## How binding a saved route is

The planner records the model and the reasoning depth to apply when the task is launched. How binding that is depends on who launches it, and the difference is real: **on the manual path both are binding**, because the user opening an executor session sets them themselves; **under supervised delivery, depth is enforced only where the environment provides one agent definition per rubric lane** (an agent file pinning model and effort together), and the supervisor dispatches by the lane matching the task's saved route. The lane set is exactly the routes this rubric can save: Sonnet 5 · xhigh, Opus 5 · high, Opus 5 · xhigh, Opus 5 · max, Fable 5 · xhigh. Creating the lane definitions is a one-time team setup in the target environment. Where no lanes exist, or a saved route has no matching lane, the launch call carries a model and no depth: the depth becomes a request in the worker's prompt that nothing can verify — say that plainly once at the start of the run, not on every task. Never substitute the model, and say so rather than quietly swapping when the exact route is unavailable. Use the exact model names and effort settings the team's environment offers (settled in step 1).

## The rubric

Use it when the current Claude models are available; with a different model set, map to the nearest equivalents and say so. Capability-first: it deliberately values avoiding a failed session over minimizing spend.

| Task profile | Recommend |
|---|---|
| Mechanical, fully specced copy of a verified pattern; reversible and concretely checkable | **Sonnet 5 · xhigh** — the only default Sonnet lane |
| Standard bounded delivery with a clear pattern — a routine feature, analysis, or templated deliverable | **Opus 5 · high** |
| Hard but well-bounded work — tricky logic, hidden invariants, or dense structure | **Opus 5 · xhigh** |
| Cross-file or cross-document coordination, data migrations, permissions/security, money, or high-stakes hard-to-reverse work (brand-defining copy, legal text, anything published where wrong is costly) | **Opus 5 · xhigh**, with Review required |
| Genuinely open design or long-horizon problem where the approach itself is uncertain | **Fable 5 · xhigh**, only after confirming availability and that its mandatory 30-day data retention is acceptable; otherwise **Opus 5 · xhigh** |
| Broad read-only audit or "find/verify every X" sweep | **Opus 5 · xhigh**, plus `/effort ultracode` only with the user's explicit opt-in |

Every Fable 5 recommendation, at any effort, requires confirmed availability and acceptance of its mandatory 30-day data retention. If either condition fails, use Opus 5 at the best compatible effort for the task.

## Effort vocabulary

| Setting | Octoplan policy |
|---|---|
| `low` | Native effort, but do not recommend it for Sonnet 5, Opus 5, or Fable 5 work. |
| `medium` | Native effort, but recommend it only when the user explicitly prioritizes latency or cost; never use it for Sonnet 5. |
| `high` | Default substantive route for Opus 5. It may be used with Fable 5 when the user already chose Fable for a bounded capability-sensitive task. Never use it for Sonnet 5. |
| extra high (`xhigh`) | Minimum Sonnet 5 route and the default for hard, long-running, or consequential work. |
| `max` | Rare. Recommend it only when `xhigh` has proved insufficient or the task is explicitly unconstrained and the extra latency, cost, and risk of overthinking are justified; write that reason in the Exec line. Prefer moving from Sonnet 5 to Opus 5 before maxing Sonnet. |
| `ultra` / `ultracode` | Not a native effort above `max`. The `/effort ultracode` session setting combines `xhigh` with automatic workflow orchestration; the `ultracode` prompt keyword starts one workflow at the session's current effort. Save the actual native effort, name the separate opt-in, and never write `effort: ultra`. |

Sonnet 5 below `xhigh` is outside this rubric. That floor is an Octoplan quality policy, not a claim that lower effort has a universally measured defect rate.

The native effort ladder and model defaults come from Anthropic's [effort guide](https://platform.claude.com/docs/en/build-with-claude/effort) and [model-selection guide](https://platform.claude.com/docs/en/about-claude/models/choosing-a-model). Claude Code's separate orchestration modes are defined in its [workflow guide](https://code.claude.com/docs/en/workflows).

## Review lenses

A required Review line names its lens count in its why: one fresh reviewer by default; two or three single-lens reviewers where a mistake cannot be taken back (schema, permissions, privacy, money, publishing). These are floors, and the delivery mode never lowers them: proportionality adds lenses to risk, it never drops the fresh review a material change gets; and where the task consumes or produces another task's artifact, one lens is the wiring — does the composed path run in production, not just in a fixture. A second lens that would re-read the same work with the same question is a duplicate, not a check. The supervisor — or the executor on the manual path — may add a lens, and may drop one only for a re-review narrower than the round before, naming which and why on the task.

**The reviewer gets a route too, and it is never cheaper than the work it attacks:** the same model, asked for extra high depth, dispatched by lane where lanes exist; where no lane covers its route, the same request-not-enforce limit applies to a spawned reviewer's depth as to a worker's.
