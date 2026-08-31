# Octoplan Codex 18.1.1 conformance

This checklist maps the shared Octoplan core and every v17.2 guarantee family to its canonical v18 location. It is a release-review aid, not runtime state. Unprefixed skill paths are relative to `skills/octoplan/`.

## Shared core

| Guarantee | Canonical v18 location |
|---|---|
| F1, Octopad control plane | `skills/octoplan/SKILL.md` > Shared foundation; `references/planning.md` > Persist and hand off |
| F2, adaptive topology | `SKILL.md` > F2; `references/planning.md` > Phase 2; `references/multi-stream.md` |
| F3, progressive complexity | `SKILL.md` > Load only what the active phase needs |
| F4, Brief playback always confirmed | `SKILL.md` > F4; `references/planning.md` > Phase 1 |
| F5, falsifiable Plan | `SKILL.md` > F5; `references/planning.md` > Phases 2 and 3 |
| F6, review bound to exact state | `SKILL.md` > F6 task-and-revision rule; `references/planning.md` > Phase 3 |
| F7, every safe ready branch advances | `SKILL.md` > F7; `references/codex-supervision.md` > Phase 4 |
| F8, interruption never lowers safety | `SKILL.md` > Interruption levels; `references/codex-supervision.md` > Phase 5 |
| F9, recoverable ownership | `SKILL.md` > F9; `references/recovery.md` > actor reconciliation and supervisor change |
| F10, closure from integrated evidence | `SKILL.md` > F10 domain-equivalence rule; `references/codex-supervision.md` > Phase 6 closure predicate and recap trigger |
| F11, plain consequence language | `SKILL.md` > F11; fixed Brief, Plan, and Delivery shapes in the phase references |
| F12, fixed visible program | `SKILL.md` > One visible program; exact banners repeated in the phase references |
| F13, protected effects including spend and irreversibility | `SKILL.md` > F13 |
| Review floors | `SKILL.md` > Review floors; phase references point to it |
| Plan-review receipt durability and route degradation | `references/planning.md` > exact task revisions and receipt persistence; `references/codex-runtime.md` > one note per run |
| Undisclosed-event consent | `SKILL.md` > Interruption levels; `references/planning.md` > persisted delivery authorization |
| Shared work-state vocabulary | `SKILL.md` > F10 domain-equivalence rule; `references/multi-stream.md` > Close precisely; `references/codex-supervision.md` > Phase 6 recap trigger |
| Shared/runtime boundary | `SKILL.md` > Shared/runtime boundary; runtime mechanics in `references/codex-runtime.md` and `references/recovery.md` |

## v18.1 corrective guarantees

| Guarantee | Canonical v18.1 location |
|---|---|
| A1, stakes and proportionality | `references/planning.md` > Phase 2 planning-overhead budget; `SKILL.md` > Review floors |
| A2, review convergence budget | `references/planning.md` > stakes round ceiling and Phase 3 enforcement |
| A3, kill-question stop | `references/codex-supervision.md` > Phase 4 stop rule |
| A4, shared-infrastructure distress | `references/recovery.md` > Stop for shared-infrastructure distress |
| A5, user-mandate sweeps | `references/recovery.md` > Replan without stale state |
| A6, rig parity and rehearsal | `references/planning.md` > proof lenses |
| A7, upstream premise verdict | `references/planning.md` > proof lenses and Phase 3 |
| A8, position and outcome reporting | `references/codex-supervision.md` > Enter or resume |
| A9, monotonic authority | `SKILL.md` > interruption levels and qualified standing intent; `references/planning.md` > per-effect authorization mapping |
| A10, escalation ownership and stalls | `references/codex-supervision.md` > Consequence handoff |
| A11, countable handoff and worthless assumption | `references/codex-supervision.md` > Consequence handoff |
| A12, interpretation playback | `SKILL.md` > F4; `references/planning.md` > Phase 1 interpretation Decision |
| A13 and P1-7, access map and remote preflight | `references/planning.md` > human-only access task; `references/codex-supervision.md` > dependency-scoped remote proof |
| A14, verified written records | `SKILL.md` > F1; `references/planning.md` > Persist and hand off |
| P0-1, immutable review and authorization receipts | `SKILL.md` > F6; `references/planning.md` > Phase 3 and activation |
| P0-2, pre-effect interlock | `references/codex-supervision.md` > Phase 5 |
| P0-3, new task after material-premise rerun | `references/recovery.md` > Replan without stale state |
| P0-4, durable closure interlock | `references/codex-supervision.md` > Phase 6 |
| P1-5, outcome frontier without a file cap | `references/codex-supervision.md` > Phase 4 |
| P1-6, handover acceptance | `references/planning.md` > handoff; `references/recovery.md` > Hand off durably |
| P1-8, real-target proof class | `references/planning.md` > proof lenses; `references/codex-supervision.md` > Proof and review |
| P1-9, tracker non-authority | `references/planning.md` > Persist and hand off |
| P1-10, native continuity guidance | `references/codex-runtime.md` > Native tasks; `references/codex-supervision.md` > Phase 4. Atomic Goal, session, thread-routing, and ownership enforcement remain runtime work. |

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
| Literal task sections, impact fields, and dependency rationales | `references/planning.md` > executable task contract and Persist and hand off |
| `How` stays outcome-led; techniques and precedents require verified fit | `references/planning.md` > executable task contract |
| Unavailable login, seat, or drivable UI becomes a named gate, not a false Verify step | `references/planning.md` > executable task contract |
| Consumed outputs get dependency edges; each user-facing text surface has one final owner | `references/planning.md` > executable task contract; `references/codex-supervision.md` > Phase 4 |
| Repository, content, research, and operations keep distinct proof lenses | `references/planning.md` > proof lenses; `references/codex-supervision.md` > Proof and review |
| Fresh plan challenge, stable recheck, material-replan reset, and complete finding dispositions | `SKILL.md` > Review floors; `references/planning.md` > Phase 3 finding-disposition and targeted-recheck rules. The former one-review rule remains for low risk and rises to two independent lenses at the shared high-risk floor. |
| Review PASS binds the exact persisted task set and revision timestamps | `SKILL.md` > F6; `references/planning.md` > Phase 3 receipt and activation checks |
| Plan contract, delivery authorization, and current-supervisor Decision remain distinct | `references/planning.md` > Persist and hand off |
| Exact Luna/Sol route table, role floors, capability-conditional observed-route proof, declared-route degradation, and no substitution on a known mismatch | `references/codex-runtime.md` > Exact route table |
| Small sequential work stays inline; delegation requires net benefit and bounded prompts | `references/codex-runtime.md` > Native tasks and delegation; `references/codex-supervision.md` > Worker prompt |
| Exact task binding and write-conflict-aware parallelism | `references/codex-runtime.md` > Native tasks and delegation; `references/multi-stream.md` |
| Disclosed effects, selected user checkpoints, and house-rule gates remain in the reviewed Plan | `references/planning.md` > Phase 2 and persisted delivery authorization |
| A wait blocks only dependent work | `SKILL.md` > F7; `references/multi-stream.md` > Supervise one ready frontier |
| Actor or effect existence is reported only after a returned or authoritative result | `references/codex-supervision.md` > Phase 4; `references/recovery.md` > effect and actor reconciliation |
| Task close gets one compact evidence comment, not another log | `references/codex-supervision.md` > Phase 4 |
| Minted user-facing wording records exact strings on its unstarted owner or triggers replan | `references/codex-supervision.md` > Phase 4 |
| Review cannot enlarge `Done when`; blocking findings need a real rule, reviewed proof, gate, or correctness basis | `references/codex-supervision.md` > Proof and review |
| Tests that can bypass production require negative proof at the real call site | `references/codex-supervision.md` > Proof and review |
| Unplanned persistent verification infrastructure is scope expansion or a material replan | `references/codex-supervision.md` > Proof and review |
| Non-idempotent effects use stable keys, authoritative inspection, and absence-proved retry | `references/codex-supervision.md` > Phase 5 pre-effect loading trigger; `references/recovery.md` > Reconcile effects before retrying |
| Retry or replacement checks the authoritative target; a successor waits for predecessor stop | `SKILL.md` > F9; `references/recovery.md` > Reconcile actors before replacement |
| Recovery shares a two-route budget and diagnoses two no-progress cycles before more work | `SKILL.md` > two-cycle recovery loading trigger; `references/recovery.md` > Bound recovery |
| One supervisor is recorded as a stream Decision and changed with `expected_updated_at` | `SKILL.md` > F9; `references/recovery.md` > Change supervisor safely |
| Goals never transfer or receive false completion | `references/recovery.md` > Change supervisor safely; `references/codex-supervision.md` > Phase 6 |
| Human waits and completion retain the localized six-field Markdown handoff | `references/codex-supervision.md` > Consequence handoff wait trigger and Phase 6 recap trigger |
| The accepted Plan shows the created graph, open questions, gates, and first ready work | `references/planning.md` > fixed Plan shape and Persist and hand off |
| Native blocked requires the same real impasse for three Goal turns | `references/codex-supervision.md` > Consequence handoff |
| Closure rejects active tasks, unresolved effects, stale task revisions, or missing continuations | `references/codex-supervision.md` > Phase 6 completion predicate and residual-risk recap |
| Pre-v18 state carries no PASS, authority, action, supervisor, or Goal ownership | `references/codex-supervision.md` > Enter or resume recovery trigger; `references/recovery.md` > Replan without stale state |

## Release surfaces

- [x] Skill `Version:` and plugin manifest use `18.1.1`.
- [x] README behavior and version describe Brief, Plan, and Delivery.
- [x] Proportionate validation covers fixed banners, mode names, closure vocabulary, release sync, review-floor arithmetic, file sets, protected invariants, and size caps.
- [x] Autopilot sources are outside this release.
