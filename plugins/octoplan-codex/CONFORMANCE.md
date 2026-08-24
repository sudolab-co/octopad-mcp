# Octoplan Codex 18.0.0 conformance

This checklist maps the shared Octoplan core and every v17.2 guarantee family to its canonical v18 location. It is a release-review aid, not runtime state. Unprefixed skill paths are relative to `skills/octoplan/`.

## Shared core

| Guarantee | Canonical v18 location |
|---|---|
| F1, Octopad control plane | `skills/octoplan/SKILL.md` > Shared foundation; `references/planning.md` > Persist and hand off |
| F2, adaptive topology | `SKILL.md` > F2; `references/planning.md` > Phase 2; `references/multi-stream.md` |
| F3, progressive complexity | `SKILL.md` > Load only what the active phase needs |
| F4, Brief playback always confirmed | `SKILL.md` > F4; `references/planning.md` > Phase 1 |
| F5, falsifiable Plan | `SKILL.md` > F5; `references/planning.md` > Phases 2 and 3 |
| F6, review bound to exact state | `SKILL.md` > F6; `references/planning.md` > Phase 3 |
| F7, every safe ready branch advances | `SKILL.md` > F7; `references/codex-supervision.md` > Phase 4 |
| F8, interruption never lowers safety | `SKILL.md` > Interruption levels; `references/planning.md` > Phase 2 Checkpoints default and Full autonomy cadence; `references/codex-supervision.md` > Delivery contact policy and Phase 5 interruption branches |
| F9, fenced and recoverable ownership | `SKILL.md` > recovery loading triggers; `references/codex-supervision.md` > Phase 5 `OCTOPLAN_ACTION` pre-effect trigger; `references/recovery.md` > effect and ownership reconciliation |
| F10, closure from integrated evidence | `SKILL.md` > F10 domain-equivalence rule; `references/codex-supervision.md` > Phase 6 closure predicate and recap trigger |
| F11, plain consequence language | `SKILL.md` > F11; fixed Brief, Plan, and Delivery shapes in the phase references |
| F12, fixed visible program | `SKILL.md` > One visible program; exact banners repeated in the phase references |
| F13, spend protected by default | `SKILL.md` > F13 billing trigger; `references/planning.md` > Phase 2 disclosed-effects catch-all; `references/codex-runtime.md` > Delivery review and protected effects inventory |
| Review floors | `SKILL.md` > Review floors; `references/planning.md` > Phase 3 floor and failure-containment lens; `references/codex-supervision.md` > Phase 4 review trigger and Phase 6 closure predicate |
| Plan-review receipt durability | `references/planning.md` > Phase 3 draft-receipt rule; Persist and hand off step 4 durability trigger |
| Undisclosed-event consent | `references/codex-runtime.md` > Authority consent-recording rule; `references/codex-supervision.md` > Phase 5 undisclosed-event branch and material-replan trigger |
| Shared work-state vocabulary | `SKILL.md` > F10 domain-equivalence rule; `references/multi-stream.md` > Close precisely; `references/codex-supervision.md` > Phase 6 recap trigger |
| Shared/runtime boundary | `SKILL.md` > Shared/runtime boundary; runtime mechanics in `references/codex-runtime.md` and `references/recovery.md` |

## v17.2 guarantee retention

| v17.2 guarantee family | Canonical v18 location |
|---|---|
| Explicit-only invocation and no generic execution | `SKILL.md` frontmatter; `agents/openai.yaml` policy |
| Durable Octopad truth, no private control plane or duplicate report | `SKILL.md` > F1; `references/codex-supervision.md` > Phase 4 |
| Resume from current Decisions, tasks, receipts, Goal, rules, and artifacts | `references/codex-supervision.md` > Enter or resume current-state read and pre-v18 recovery trigger |
| Outcome, proof, scope, constraints, assumptions, ownership, effects, and gates captured before activation | `references/planning.md` > Phases 1 and 2 |
| Planning-only permission never authorizes delivery | `references/planning.md` > Phase 2 and Persist and hand off |
| Live Octopad schemas and effective target rules remain the floor | `SKILL.md` > Shared/runtime boundary; `references/planning.md` > Enter or resume |
| Fewest coherent tasks for the first integrated result; no fake approval or status tasks | `references/planning.md` > Phase 2 |
| Literal task sections, impact fields, dependency rationales, and immutable Plan refs | `references/planning.md` > executable task contract and Persist and hand off |
| `How` stays outcome-led; techniques and precedents require verified fit | `references/planning.md` > executable task contract |
| Unavailable login, seat, or drivable UI becomes a named gate, not a false Verify step | `references/planning.md` > executable task contract |
| Consumed outputs get dependency edges; each user-facing text surface has one final owner | `references/planning.md` > executable task contract; `references/codex-supervision.md` > Phase 4 |
| Repository, content, research, and operations keep distinct proof lenses | `references/planning.md` > proof lenses; `references/codex-supervision.md` > Proof and review |
| Fresh plan challenge, stable recheck, material-replan reset, and complete finding dispositions | `references/planning.md` > Phase 3 floor trigger, finding-disposition rule, and targeted-recheck rule. The former one-review rule remains for low risk and rises to two independent lenses at the shared high-risk floor. |
| Canonical SHA-256 review packet excludes generated state and must match persisted stream/task refs, membership, and edges exactly | `references/planning.md` > Phase 3 fingerprint recipe and activation match; Persist and hand off ref-to-ID reconstruction |
| Plan contract, delivery authorization, and guarded supervisor lease remain distinct | `references/planning.md` > Persist and hand off steps 4–5, delivery-authorization paragraph, and supervisor-lease paragraph |
| Exact Luna/Sol route table, role floors, observed-route proof, and no substitution | `references/codex-runtime.md` > Exact route table |
| Small sequential work stays inline; delegation requires net benefit and bounded prompts | `references/codex-runtime.md` > Native tasks and delegation; `references/codex-supervision.md` > Worker prompt |
| Readable native titles, exact task binding, and write-conflict-aware parallelism | `references/codex-runtime.md` > Native tasks and delegation; `references/multi-stream.md` |
| Disclosed effects, selected user checkpoints, and house-rule clearances bind to the exact reviewed Plan | `references/planning.md` > Phase 2 disclosure and default-marking triggers plus delivery-authorization selection; `references/codex-supervision.md` > Phase 5 selected-checkpoint and house-rule branches |
| A wait blocks only dependent work | `SKILL.md` > F7; `references/multi-stream.md` > Supervise one ready frontier |
| Actor or effect existence is reported only after a returned or authoritative result | `references/codex-supervision.md` > Phase 4; `references/recovery.md` > effect and dispatch reconciliation |
| Task close gets one compact evidence comment, not another log | `references/codex-supervision.md` > Phase 4 |
| Minted user-facing wording records exact strings on its unstarted owner or triggers replan | `references/codex-supervision.md` > Phase 4 |
| Review cannot enlarge `Done when`; blocking findings need a real rule, reviewed proof, gate, or correctness basis | `references/codex-supervision.md` > Proof and review |
| Tests that can bypass production require negative proof at the real call site | `references/codex-supervision.md` > Proof and review |
| Unplanned persistent verification infrastructure is scope expansion or a material replan | `references/codex-supervision.md` > Proof and review |
| Non-idempotent effects use stable keys, authoritative inspection, and absence-proved retry | `references/codex-supervision.md` > Phase 5 pre-effect loading trigger; `references/recovery.md` > Reconcile effects before retrying |
| Dispatch creates once; replacement waits for predecessor stop and effect quiescence | `references/recovery.md` > Reconcile dispatch before replacement |
| Recovery shares a two-route budget and diagnoses two no-progress cycles before more work | `SKILL.md` > two-cycle recovery loading trigger; `references/recovery.md` > Bound recovery |
| Takeover uses guarded lease rotation, quiescence proof, predecessor fencing, and a new Goal | `references/recovery.md` > Rotate supervisor ownership safely |
| Goals never transfer or receive false completion | `references/recovery.md` > Rotate supervisor ownership safely; `references/codex-supervision.md` > Phase 6 |
| Human waits and completion retain the localized six-field Markdown handoff | `references/codex-supervision.md` > Consequence handoff wait trigger and Phase 6 recap trigger |
| The accepted Plan shows the created graph, open questions, gates, and first ready work | `references/planning.md` > fixed Plan shape and Persist and hand off |
| Native blocked requires the same real impasse for three Goal turns | `references/codex-supervision.md` > Consequence handoff |
| Closure rejects active tasks or dispatches, unresolved effects, stale review, or missing gates | `references/codex-supervision.md` > Phase 6 completion predicate and residual-risk recap |
| Pre-v18 state carries no PASS, authority, action, lease, supervisor, or Goal ownership | `references/codex-supervision.md` > Enter or resume recovery trigger; `references/recovery.md` > Replan without stale state |

## Release surfaces

- [x] Skill `Version:` and plugin manifest use `18.0.0`.
- [x] README behavior and version describe Brief, Plan, and Delivery.
- [x] Deterministic validation covers fixed banners, review floors, interruption semantics, state binding, routing, recovery, and closure.
- [x] Autopilot sources are outside this release.
