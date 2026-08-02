# Codex routing and execution consent

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

## Supervisor routing

Route the supervisor by scheduling and recovery difficulty, never by the hardest child artifact. Inline supervision uses the current Sol planning or recovery session. A dedicated parent defaults to `gpt-5.6-terra · effort xhigh`; use Terra `max` for difficult bounded fan-in or multi-stream reconciliation and Sol only when orchestration itself has open ambiguity, weak verification, or costly irreversible consequences. Save why each cheaper route is inadequate.

## Failure diagnosis and escalation

Diagnose before changing routes:

- Missing or contradictory context: return to a fresh Sol `xhigh` Octoplan pass.
- Environment, access, or verifier failure: repair the blocker without changing model.
- Confirmed executor capability miss on a sound bounded task: use only its saved fallback; do not walk every effort level.
- Reviewer capability miss: revise and review that route, then request fresh consent.
- Material scope or risk change: stop and replan.

Before consent, an optional executor fallback may be saved. Its stamp names the exact route, maximum replacements, failed criterion, evidence count, and observations required to establish that prompt, context, access, environment, and verifier are sound. The count is at least two; never infer capacity from elapsed time or hidden reasoning.

During execution, the supervisor may use that saved fallback only when every clause is durably proven and its bound remains. It starts a fresh attempt and thread; it never retargets the failed session. Any unsaved route or changed task meaning requires a reviewed replan, fresh consent, run ID, and fingerprint. A direct user instruction naming the task, already-saved fallback route, and one replacement is a new bounded routing decision, not proof that the trigger matched.

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

The reviewer may share the executor's model family when that is the cheapest adequate route. Independence comes from a fresh thread and source-first inspection; model diversity matters only when it adds a distinct detection lens. The lead owns corrections and task completion but never launches a successor. A saved specialist reviews only its mandate, reports to the lead, and never completes or relays.

Plan review uses fresh `spawn_agent` subagents, never user-owned threads. Use Terra `xhigh` for routine bounded plans, Terra `max` for difficult bounded reconciliation, and Sol only for open ambiguity, weak verification, or costly consequences. Save the exact supported route and why cheaper support is inadequate.

## Execution consent

Completing a plan never authorizes execution. State the reviewed plan hash, then end the planning response in the conversation language with this meaning, adapted only for natural grammar:

> The plan is complete and verified. Would you like me to start execution now?
>
> If you accept, Codex will apply the saved conditional supervision policy and automatically create any justified parent plus executor, reviewer, and bounded replacement sessions at the exact saved routes and native project targets. It will run only tasks explicitly proven independent in parallel and stop at human gates, material plan changes, unmatched fallback conditions, exhausted bounds, or failures needing your decision.

Then stop. Do not call `list_projects`, `create_thread`, or any executor tool while waiting.

A clear yes authorizes only:

- the stated reviewed plan hash and its verified scope;
- its fingerprinted conditional supervision policy and allowed parent routes;
- its fingerprinted inline supervisor, dedicated supervisor, default executor, and task-role override targets and environments;
- its saved dedicated-parent replacement bound;
- creation and monitoring of its executor and reviewer sessions;
- the exact saved model and reasoning effort for each task;
- each saved executor fallback route, trigger, evidence threshold, and replacement bound;
- each saved same-route recovery policy and bound;
- saved parallel groups that still pass preflight.

It does not authorize a protected external action, a human-only task, a materially revised plan, an unsaved route, or a substitution outside those exact bounds.

After a clear yes, read [codex-supervision.md](codex-supervision.md) completely before creating the first session. Read it before resuming any run; a missing `octoplan-supervision-v2` contract requires replanning.
