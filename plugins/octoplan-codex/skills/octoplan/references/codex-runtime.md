# Codex routing and autonomous execution

## Route after decomposition

Minimize expected cost per accepted task: execution, required review, likely correction or retry, delay, and drift. Start with the cheapest adequate route, not the cheapest call. Split work that exceeds one focused session before raising model capacity.

1. Classify the work: engineering, research or analysis, communication or content, product or strategy, or operations.
2. Choose its cheapest plausible base route below.
3. Adjust for boundedness, verifier strength, reversibility, consequence, subjectivity, coupling, and retry cost.

| Observable profile | Exec stamp |
|---|---|
| Exact mechanical work with deterministic proof | `gpt-5.6-luna · effort high` |
| Routine bounded work with clear acceptance and strong proof | `gpt-5.6-luna · effort xhigh` |
| Difficult bounded work with strong proof | `gpt-5.6-luna · effort max` |
| Everyday non-code work where tone or interpretation matters | `gpt-5.6-terra · effort high` |
| Bounded product, analysis, communication, or editorial work | `gpt-5.6-terra · effort xhigh` |
| Difficult bounded technical or non-code work needing judgment beyond Luna, without open ambiguity or severe irreversible consequence | `gpt-5.6-terra · effort max` |
| Difficult open-ended work, weak verification, or high-value subjective synthesis | `gpt-5.6-sol · effort high` |
| High-consequence work whose material failure is hard to detect or costly to reverse | `gpt-5.6-sol · effort xhigh` |
| Open architecture or investigation with broad coupling and no reliable bounded verifier | `gpt-5.6-sol · effort max` |

Treat a task as mixed when it combines objectively specified implementation with qualitative product, UX, editorial, semantic, or cross-domain acceptance. Route execution through the full rubric using only choices the executor must originate; judgment assigned only to independent review does not elevate execution. If the executor must originate material judgment, apply the relevant Terra or Sol row. Split separable work first.

A label such as authentication, private data, integrity, concurrency, public, or production never selects a route alone. Risk raises a route only when paired with weak detection or costly irreversibility; strong proof and cheap rollback can keep bounded work on Luna or Terra. Every Sol executor or reviewer rationale must name the observable reason Luna and Terra are inadequate. If it cannot, choose the cheaper adequate route.

Terra is a technical and non-code capacity rung, not a quota. `ultra` means parallel delegation for genuinely independent partitions with user opt-in, never “very hard.” Do not silently change a saved model or effort.

Routing basis: [OpenAI model guidance](https://learn.chatgpt.com/docs/models#choosing-sol-terra-and-luna), [OpenAI outcome routing](https://openai.com/index/advancing-the-price-performance-frontier-with-gpt-5-6/#matching-intelligence-to-the-outcome), [DeepSWE](https://deepswe.datacurve.ai/), [HUMAINE](https://www.prolific.com/resources/gpt-5-6-joins-the-humaine-leaderboard-how-sol-terra-and-luna-rank-with-real-people), and [Box Complex Work Eval](https://blog.box.com/how-gpt-56-handles-real-enterprise-work). Treat cross-domain transfer as a default to validate on accepted Octoplan results, not a universal ranking.

## Failure diagnosis and escalation

Diagnose before changing routes:

- Missing or contradictory context: return to a fresh Sol `xhigh` Octoplan pass.
- Environment, access, or verifier failure: repair the blocker without changing model.
- Confirmed capability miss on a sound bounded task: choose the next justified route; do not walk every effort level.
- Tone, persuasion, or strategic-judgment miss: escalate the failed executor or reviewer according to the saved evidence.
- Material scope or risk change: stop and replan.

Any changed Exec, Review, or Specialist review stamp is a material task rewrite. Save and review it, ask the execution-consent question again, and wait. Only a fresh approved run creates replacement work.

## Review routing

Every executable task receives one fresh independent review. Choose its route by detection difficulty, not executor prestige:

| Detection target | Lead review route |
|---|---|
| Exact mechanical result with deterministic proof | `gpt-5.6-luna · effort high` |
| Routine bounded completeness, tests, constraints, or reproducibility | `gpt-5.6-luna · effort xhigh` |
| Difficult deterministic logic or proof | `gpt-5.6-luna · effort max` |
| Everyday tone, factual, UX, or editorial check | `gpt-5.6-terra · effort high` |
| Bounded product, evidence, integration, or editorial judgment | `gpt-5.6-terra · effort xhigh` |
| Subtle bounded cross-domain or technical judgment | `gpt-5.6-terra · effort max` |
| Difficult cross-domain defects, materially weak verification, or high-value subjective judgment | `gpt-5.6-sol · effort high` |
| Security, privacy, permissions, money, destructive data, production mutation, legal, or public harm when failure is hard to detect or reverse | `gpt-5.6-sol · effort xhigh` |
| Open architecture or investigation | `gpt-5.6-sol · effort max` |

Use one reviewer by default. Add one simultaneous specialist only when the artifact has two genuinely orthogonal failure domains and at least one is weakly verified or costly to miss. Give lead and specialist non-overlapping mandates; duplicate generic reviews are invalid. Both must PASS. Unresolved disagreement stops for evidence or human judgment and never creates a third reviewer automatically.

The reviewer may share the executor's model family when that is the cheapest adequate route. Independence comes from a fresh thread and source-first inspection; model diversity matters only when it adds a distinct detection lens. The lead owns corrections, completion, and relay. A saved specialist reviews only its mandate, reports to the lead, and never completes or relays the task.

## Execution consent

Completing a plan never authorizes execution. End the planning response in the conversation language with this meaning, adapted only for natural grammar:

> The plan is complete and verified. Would you like me to start execution now?
>
> If you accept, Codex will execute the plan in its defined order by automatically creating the required sessions, using the planned model and reasoning effort for each task. It will run only tasks that the plan explicitly declares independent in parallel. It will stop at human gates, material plan changes, or failures that need your decision.

Then stop. Do not call `list_projects`, `create_thread`, or any executor tool while waiting.

A clear yes authorizes only:

- the current saved plan and its verified scope;
- creation and monitoring of its executor and reviewer sessions;
- the exact saved model and reasoning effort for each task;
- saved parallel groups that still pass preflight.

It does not authorize a protected external action, a human-only task, a materially revised plan, or a model substitution.

After a clear yes, read [codex-relay.md](codex-relay.md) completely before creating the first task or resuming the run.
