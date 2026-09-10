# Codex runtime routing and authority

Read this before choosing a model, delegating, creating a Goal, or asking for authority.

## Authority

Apply the single authority and interruption contract in [SKILL.md](../SKILL.md). Persist the user's Plan choice and bounds in `Octoplan 18 delivery authorization`; a Goal never widens them.

A plan reviewer is read-only: it uses production Octopad and exact bounded context but cannot write, claim, complete, launch, approve, or authorize. A worker receives only the delivery authority its owning task needs. The supervisor validates all advancement and authority.

## Exact route table

Choose by detection difficulty, reversibility, and the judgment needed across the whole task. Save the exact model, effort, and short reason on every spawned task.

| Work profile | Route |
|---|---|
| Mechanical work with deterministic proof | `gpt-5.6-luna · effort max` |
| Short, bounded execution with a reliable verifier | `gpt-6-astra · effort low` |
| Bounded product, technical, or editorial judgment with several linked steps | `gpt-6-astra · effort medium` |
| Review with bounded context and reliable checks | `gpt-6-astra · effort high` |
| Planning, long supervision, open architecture, difficult investigation, weak verification, or high consequences | `gpt-6-astra · effort xhigh` |
| Exceptional reasoning difficulty that remains after diagnosis | `gpt-6-astra · effort max` |

For new choices, use Luna `max` or Astra `low|medium|high|xhigh|max`. Role admission is stricter: planner and supervisor = Astra `xhigh|max`; plan reviewer and delivery reviewer = Astra `high|xhigh|max`; worker = the table route. Use `xhigh` for reviews with weak verification or high consequences. Effort never replaces the independent review floor.

Saved Luna `max` and Sol routes remain valid without migration: planner = Sol `xhigh|max`; plan reviewer, supervisor, delivery reviewer, and worker = Sol `high|xhigh|max`. Keep each saved model and effort exactly, including active actors; do not upgrade them on resume. An explicit return to Sol uses these same role limits. Any route change returns to Plan under [planning.md](planning.md) before dispatch; it is never an automatic fallback. Other declarations or a route known to be unavailable pause the affected actor without substitution.

Compare efficiency over comparable completed tasks at the same acceptance standard, including continuations, tool calls, repeated context, and rework. Use observed usage when available; benchmark dollars, elapsed time, or quota burn per minute alone do not establish cost per accepted task. After two comparable cycles without accepted progress, diagnose under [recovery.md](recovery.md) before choosing another route. Do not infer that higher effort always costs less or raise effort automatically.

Record declared routes. When native evidence exposes model and effort, require an exact match. Positive evidence of either a wrong model or wrong effort pauses that actor without substitution. Prompt text, title, or the requested route is not observation. Otherwise continue and note once per run that the route is declared, not provable here, recording the note on the first affected receipt or owning task. Missing route metadata never makes a review fail or become `INFEASIBLE`.

## Native tasks and delegation

The current user task is the default planning and supervision target. Use a fresh supervisor after a heavy planning pass, when another Goal is active, or when isolation requires it. If runtime reports context use at 75%, prepare a safe-boundary handoff before verification capacity is lost. Create the Goal only after the supervisor is chosen and delivery is authorized.

Use a spawned worker only when isolation, specialization, independent parallelism, or context reduction is worth the handoff. Keep a small sequential task inline. Treat a creation as successful only after its call returns or the authoritative target confirms it. Before any retry or replacement, inspect that target; never recreate work merely because one response field is missing.

Every worker works only its task; its `**Octopad**` line says whether it opens Octopad. The supervisor alone closes tasks, advances the graph, validates checkpoints, and creates actors. Route a user's “continue” to that recorded owner; another thread or reviewer never acquires ownership from the message. A replacement confirms its predecessor stopped before acting.

Parallelize only tasks whose real write surfaces and outputs are independent. Never parallelize migrations, shared generated artifacts, or siblings where one shapes the other's contract.

## Delivery review and protected effects

Apply the review floor, protected-effect definition, and interruption behavior from [SKILL.md](../SKILL.md). Keep effects and gates on the owning task, not as fake delivery tasks; effective rules may add stricter waits or reviewers.
