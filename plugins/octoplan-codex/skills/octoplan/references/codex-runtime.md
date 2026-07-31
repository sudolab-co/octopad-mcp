# Codex routing and autonomous execution

## Route after decomposition

Choose by consequence, openness, ambiguity, coupling, verification strength, subjectivity, and retry cost. File count alone never chooses a model. Split an oversized task before raising its model.

Apply these rows in order:

| Observable task profile | Exec stamp |
|---|---|
| Open investigation or architecture decision | `gpt-5.6-sol · effort max` |
| Bounded authentication, permissions, payments, private data, data integrity, concurrency, destructive migration, or other costly-to-reverse implementation | `gpt-5.6-sol · effort xhigh` |
| Bounded non-sensitive synthesis with genuinely independent partitions and a real parallel gain | `gpt-5.6-sol · effort ultra`, with user opt-in |
| Public, brand-defining, persuasion-critical, legal, compliance, or other costly-to-reverse non-code work | `gpt-5.6-sol · effort xhigh` |
| High-value or open-ended strategy, positioning, or multi-source research synthesis; polished external writing with a subjective quality bar; or difficult bounded work with weak verification | `gpt-5.6-sol · effort high` |
| Mechanical exact copy, rename, text, or safe configuration with no design choice | `gpt-5.6-luna · effort high` |
| Routine low-consequence work with an exact pattern, deterministic checks, and cheap retry | `gpt-5.6-luna · effort high` |
| Standard bounded autonomous work with clear acceptance and strong deterministic verification | `gpt-5.6-luna · effort xhigh` |
| Difficult but bounded autonomous work with strong verification | `gpt-5.6-luna · effort max` |
| Everyday communication or internal content where tone and interpretation matter | `gpt-5.6-terra · effort high` |
| Routine non-code work with a verified governing template and no voice or interpretive judgment | `gpt-5.6-luna · effort xhigh` |
| Well-bounded, ordinary-consequence PRD, product brief, opportunity analysis, or decision memo with verified sources | `gpt-5.6-terra · effort xhigh` |

Luna `xhigh` is the default executor after a strong Octoplan decomposition. Use Luna `max` when the task remains difficult but its boundaries and verifier are strong. Terra is a business-work route, not a mandatory rung between Luna and Sol. Luna `medium`, Terra `medium`, and Sol `low` are outside the default path. Ultra means parallel delegation, not "very hard".

Optimize cost per accepted task: include retries, review corrections, delay, and scope drift. Do not silently change model or effort mid-session. If the profile changes, stop, save the evidence, re-route, and create a fresh session.

Routing basis: [OpenAI model guidance](https://learn.chatgpt.com/docs/models#choosing-sol-terra-and-luna), [OpenAI outcome routing](https://openai.com/index/advancing-the-price-performance-frontier-with-gpt-5-6/#matching-intelligence-to-the-outcome), [DeepSWE](https://deepswe.datacurve.ai/), [HUMAINE](https://www.prolific.com/resources/gpt-5-6-joins-the-humaine-leaderboard-how-sol-terra-and-luna-rank-with-real-people), and [Box Complex Work Eval](https://blog.box.com/how-gpt-56-handles-real-enterprise-work). Treat cross-domain transfer as a default to validate on accepted Octoplan results, not a universal ranking.

## Failure diagnosis and escalation

Do not walk every model or effort level. Diagnose and save the failure evidence first:

- Missing or contradictory task context: return to a fresh Sol `xhigh` Octoplan pass.
- Environment, access, or verifier failure: repair that blocker before changing model.
- Clear implementation miss on a sound task: propose the next justified Luna route; after a confirmed Luna `max` capacity failure, propose Sol `high` or `xhigh` according to consequence.
- Tone, voice, persuasion, or strategic-judgment miss on Luna or Terra: propose Sol `high` or `xhigh` according to consequence, using the saved brief and concrete review findings.
- Material scope or risk change: stop and replan; never hide it as a model escalation.

Any changed Exec or Review stamp is a material task rewrite. Save and review the revised route, ask the execution-consent question again, and wait. Only a fresh approved run may create the replacement session; the failed executor or reviewer never substitutes its own route.

## Review routing

`Review: required` for behavioral changes, material judgment, unfamiliar integrations, ambiguous diagnoses, weak verification, public or source-sensitive external content, or costly mistakes. `skip` is limited to exact, reversible mechanical work with deterministic proof.

| Review target | Review route |
|---|---|
| Completeness and verifiability of standard deterministic work | `gpt-5.6-luna · effort max` |
| Difficult logic, bounded ambiguity, unfamiliar integration, weak verification, editorial judgment, or Ultra synthesis | `gpt-5.6-sol · effort high` |
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
