# Codex runtime routing and authority

Read this before choosing a model, delegating, creating a Goal, or asking for authority.

## Authority

Apply the single authority and interruption contract in [SKILL.md](../SKILL.md). Persist the user's Plan choice and bounds in `Octoplan 18 delivery authorization`; a Goal never widens them.

A plan reviewer is read-only: it uses production Octopad and exact bounded context but cannot write, claim, complete, launch, approve, or authorize. A worker receives only the delivery authority its owning task needs. The supervisor validates all advancement and authority.

## Exact route table

Choose by detection difficulty and reversibility. Save the exact model, effort, and short reason on every spawned task.

| Work profile | Route |
|---|---|
| Mechanical work with deterministic proof | `gpt-5.6-luna · effort max` |
| Bounded product, technical, editorial, review, or supervision judgment | `gpt-5.6-sol · effort high` |
| Difficult, open-ended, weakly verified, or high-consequence work | `gpt-5.6-sol · effort xhigh` |
| Open architecture or investigation without a reliable verifier | `gpt-5.6-sol · effort max` |

The only automatic routes are Luna `max` and Sol `high|xhigh|max`. Other declarations pause without substitution. Role admission is stricter: planner = Sol `xhigh|max`; plan reviewer, supervisor, and delivery reviewer = Sol `high|xhigh|max`; worker = the table route.

Record declared routes. When native evidence exposes model and effort, require an exact match. Positive evidence of either a wrong model or wrong effort pauses that actor without substitution. Prompt text, title, or the requested route is not observation. Otherwise continue and note once per run that the route is declared, not provable here, recording the note on the first affected receipt or owning task. Missing route metadata never makes a review fail or become `INFEASIBLE`.

## Native tasks and delegation

The current user task is the default planning and supervision target. Use a fresh supervisor after a heavy planning pass, when another Goal is active, or when isolation requires it. If runtime reports context use at 75%, prepare a safe-boundary handoff before verification capacity is lost. Create the Goal only after the supervisor is chosen and delivery is authorized.

Use a spawned worker only when isolation, specialization, independent parallelism, or context reduction is worth the handoff. Keep a small sequential task inline. Treat a creation as successful only after its call returns or the authoritative target confirms it. Before any retry or replacement, inspect that target; never recreate work merely because one response field is missing.

Every worker starts production Octopad, reads the exact task, Decisions, and effective rules, and works only that task. The supervisor alone closes tasks, advances the graph, validates checkpoints, and creates actors. Route a user's “continue” to that recorded owner; another thread or reviewer never acquires ownership from the message. A replacement confirms its predecessor stopped before acting.

Parallelize only tasks whose real write surfaces and outputs are independent. Never parallelize migrations, shared generated artifacts, or siblings where one shapes the other's contract.

## Delivery review and protected effects

Apply the review floor, protected-effect definition, and interruption behavior from [SKILL.md](../SKILL.md). Keep effects and gates on the owning task, not as fake delivery tasks; effective rules may add stricter waits or reviewers.
