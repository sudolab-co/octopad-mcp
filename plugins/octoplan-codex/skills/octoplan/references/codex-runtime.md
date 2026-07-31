# Codex routing and autonomous execution

## Route after decomposition

Choose by consequence, openness, ambiguity, coupling, verification strength, and retry cost. File count alone never chooses a model. Split an oversized task before raising its model.

Apply these rows in order:

| Observable task profile | Exec stamp |
|---|---|
| Open investigation or architecture decision | `gpt-5.6-sol · effort max` |
| Bounded authentication, permissions, payments, private data, data integrity, concurrency, destructive migration, or other costly-to-reverse implementation | `gpt-5.6-sol · effort xhigh` |
| Bounded non-sensitive synthesis with genuinely independent partitions and a real parallel gain | `gpt-5.6-sol · effort ultra`, with user opt-in |
| Public, brand-defining, persuasion-critical, legal, compliance, or other costly-to-reverse non-code work | `gpt-5.6-sol · effort xhigh` |
| Difficult bounded logic, bounded ambiguity, unusual integration, or weak verification | `gpt-5.6-sol · effort high` |
| Mechanical exact copy, rename, text, or safe configuration with no design choice | `gpt-5.6-luna · effort medium` |
| Routine low-consequence work with an exact pattern, deterministic checks, and cheap retry | `gpt-5.6-luna · effort high` |
| Routine non-code work with a verified governing template | `gpt-5.6-luna · effort high` |
| Novel but bounded internal analysis or document with verified sources and ordinary consequences | `gpt-5.6-terra · effort high` |
| Bounded work with moderate coupling or a materially costly failed first pass | `gpt-5.6-sol · effort medium` |
| Other standard bounded autonomous work with clear acceptance and strong deterministic verification | `gpt-5.6-terra · effort high` |

Terra `high` is the ordinary fallback. Luna `medium` requires an exact result, no judgment, low consequence, reversibility, deterministic failure-catching proof, and no sensitive system. Ultra means parallel delegation, not "very hard".

Optimize cost per accepted task: include retries, review corrections, delay, and scope drift. Do not silently change model or effort mid-session. If the profile changes, stop, save the evidence, re-route, and create a fresh session.

## Review routing

`Review: required` for behavioral changes, material judgment, unfamiliar integrations, ambiguous diagnoses, weak verification, or costly mistakes. `skip` is limited to the same mechanical conditions that permit Luna `medium`.

| Review target | Review route |
|---|---|
| Standard deterministic behavior or bounded internal judgment | `gpt-5.6-sol · effort medium` |
| Difficult logic, bounded ambiguity, unfamiliar integration, weak verification, or Ultra synthesis | `gpt-5.6-sol · effort high` |
| Sensitive, destructive, private-data, permission, payment, concurrency, public persuasion, legal, or compliance work | `gpt-5.6-sol · effort xhigh` |
| Open investigation or architecture decision | `gpt-5.6-sol · effort max` |

Use a fresh reviewer with no authoring history. The executor creates that review session at the saved Review route and transfers continuation ownership to it; the executor never reviews its own work. The reviewer sends confirmed findings to the original executor, monitors the correction loop, reruns affected verification, and may complete and relay the task only after PASS.

## Execution consent

Completing a plan never authorizes execution. End the planning response in the conversation language with this meaning, adapted only for natural grammar:

> The plan is complete and verified. Would you like me to start execution now?
>
> If you accept, Codex will execute the plan in its defined order by automatically creating the required sessions, using the planned model and reasoning effort for each task. It will run only tasks that the plan explicitly declares independent in parallel. It will stop at human gates, material plan changes, or failures that need your decision.

Then stop. Do not call `list_projects`, `create_thread`, or any executor tool while waiting.

A clear yes authorizes only:

- the current saved plan and its verified scope;
- creation and monitoring of its executor sessions;
- the exact saved model and reasoning effort for each task;
- saved parallel groups that still pass preflight.

It does not authorize a protected external action, a human-only task, a materially revised plan, or a model substitution.

After a clear yes, read [codex-relay.md](codex-relay.md) completely before creating the first task or resuming the run.
