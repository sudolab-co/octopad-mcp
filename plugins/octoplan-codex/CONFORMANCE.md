# Octoplan 2.0.0 conformance

This is a reviewer aid for both native distributions, not runtime state or a declaration that behavior passed. Both packages copy `skills/octoplan/` byte for byte; paths below are relative to that canonical source. Review the final shared protocol and each affected runtime profile, including the deliberate changes below.

**Release and saved state are separate.** `2.0.0` is the shared source and package version. New plans use the common `Octoplan brief`, `Octoplan stakes`, `Octoplan plan contract`, `Octoplan delivery authorization`, and `Octoplan supervisor` Decision names. Existing Codex v18 aliases and Claude mode-based records remain readable without renaming, new fields, or duplicate consent. The release does not renumber the Codex plan-contract generation. Compatibility still requires current scope, revisions, authority, effects and ownership to be valid; a familiar title never turns stale evidence into PASS.

## Shared foundation

| Review subject | Source |
|---|---|
| F1: verified durable Octopad truth, no secrets or shadow control plane | `SKILL.md` > Shared foundation; `references/planning.md` > Persist and hand off |
| F2–F3: smallest useful topology and progressive loading | `SKILL.md` > Shared foundation and Load only what the work needs; `references/multi-stream.md` |
| F4: confirmed interpretation, replayed on unchanged resume | `references/planning.md` > Phase 1: confirm the Brief |
| F5: falsifiable outcome, material premises and kill question | `references/planning.md` > Phase 2: compose the Plan |
| F6: immutable review bound to exact tasks and contract revisions | `references/planning.md` > Phase 3: challenge and activate |
| F7: safe ready work advances; waits affect only their consumers | `references/supervision.md` > Phase 4: advance the ready frontier; `references/multi-stream.md` |
| F8: mode changes interruption, never safety or effect coverage | `SKILL.md` > Autonomy and authority; `references/supervision.md` > Phase 5: reconcile change and interruption |
| F9: one guarded owner, actor reconciliation before replacement | `references/recovery.md` > Reconcile actors before replacement and Change supervisor safely |
| F10: integrated closure and distinct lifecycle states | `references/supervision.md` > Phase 6: prove closure or hand off |
| F11–F12: consequence language and the same Brief/Plan/Delivery program | `SKILL.md` > One visible program; `references/supervision.md` > Consequence handoff |
| F13: actual target and authority for spend or irreversible effects | `SKILL.md` > Shared foundation and Autonomy and authority |
| F14: target rules, installed skills, hooks and permissions remain binding | `SKILL.md` > Shared foundation; `references/supervision.md` > Worker prompt |

## Earlier guarantee families to inspect

These identifiers preserve review navigation from prior releases. They are not extra requirements or proof that every former implementation detail remains unchanged.

| Prior family | Current inspection surface |
|---|---|
| A1–A2: proportional planning and review convergence | `references/planning.md` > Phase 2 and Phase 3; `SKILL.md` > Review floors. Inspect real ceilings and diagnose non-progress without manufacturing a user gate. |
| A3–A5: kill question, infrastructure containment and mandate sweep | `references/supervision.md` > Phase 4; `references/recovery.md` > Stop for shared-infrastructure distress and Replan without stale state |
| A6–A7, P1-8: input fitness, real-target parity and proof rehearsal | `references/planning.md` > Phase 2 proof lenses; `references/supervision.md` > Proof and review |
| A8, A10–A11: countable progress, consequence ownership and meaningful waits | `references/supervision.md` > Enter or resume and Consequence handoff |
| A9, A12: monotonic authority and interpretation playback | `SKILL.md` > Autonomy and authority; `references/planning.md` > Phase 1 and Agree autonomy before detailing the Plan |
| A13, P1-7: actual access and dependency-scoped remote proof | `references/planning.md` > Phase 2; `references/supervision.md` > Phase 4 |
| A14, P0-1: verified records and immutable review/authorization receipts | `SKILL.md` > F1 and F6; `references/planning.md` > Phase 3 and Persist and hand off |
| P0-2–P0-4: pre-effect, premise-rerun and closure interlocks | `references/supervision.md` > Phase 5 and Phase 6; `references/recovery.md` > Reconcile effects before retrying and Replan without stale state |
| P1-5–P1-6: complete ready frontier and accepted handover | `references/supervision.md` > Phase 4 and Phase 6; `references/recovery.md` > Hand off durably |
| P1-9–P1-10: tracker has no authority; native continuity is explicit | `references/planning.md` > Persist and hand off; selected runtime profile; `references/continuation.md` |
| v17.2 task contract: literal sections, impact, bounded How/Verify, output owners and dependency rationales | `references/planning.md` > Phase 2 and Persist and hand off |
| v17.2 proof: fresh review, complete finding dispositions, no inflated Done when or irrelevant green proof | `SKILL.md` > Review floors; `references/planning.md` > Phase 3; `references/supervision.md` > Proof and review |
| v17.2 effects: stable keys, absence-proved retry and no speculative actor replacement | `references/recovery.md` > Reconcile effects before retrying and Reconcile actors before replacement |
| v17.2 persistence: task receipts, exact wording ownership, guarded supervisor and six-field handoff | `references/supervision.md` > Phase 4, Consequence handoff and Phase 6; `references/recovery.md` > Hand off durably |
| v17.2 compatibility: exact routes and valid saved consent; unsupported objects are historical evidence | Each runtime's compatibility section; `references/recovery.md` > Resume without a forced migration |

## Deliberate changes and runtime checks

- **Early mandate:** Brief confirmation still permits planning only. The mode and delivery mandate are agreed before detailed planning, then reused within their actual scope after the reviewed Plan is shown. A new consequence asks only for its authority delta.
- **Fresh actors:** a fresh supervisor owns Delivery and dispatches workers; the original parent relays user dialogue and manages supervisor lifecycle. This replaces the former inline-worker default. A planner repairing the Plan does not silently take over Delivery. Verify the actual native launch, follow-up and stop capabilities before offering this route.
- **Diagnosis:** two comparable cycles without accepted progress trigger internal diagnosis and a different defensible strategy, not an automatic user question. Real spend/attempt limits and house rules still bind; independent safe work continues.
- **Context:** respect a user preference around 60% at a natural boundary using reliable runtime signals. This is not a fabricated measurement or per-task token quota. Prove the predecessor stopped before launching a successor; a saved Next pointer is not a live actor.
- **Codex:** inspect `references/codex-runtime.md` for exact saved model/effort enforcement, declared-versus-observed route evidence, the parent relay and optional parent-owned Goal. Children never mutate that Goal; supervisor retirement does not complete the global objective. Native blocked thresholds apply to genuine Goal turns, not polls.
- **Claude:** inspect `references/claude-runtime.md` for available pinned lanes versus explicitly request-only effort, Fable availability and data-handling consent, native effort versus workflow opt-in, supervisor/reviewer route floors and real parent/child capability checks. No Codex Goal or invented Claude tool is assumed.
- **Fallback and compatibility:** `references/continuation.md` discloses manual launch honestly. Existing manual continuations and valid saved routes remain usable; names, new defaults or absent optional fields do not force a migration or enlarge authority.

## Release verification

Run `sh scripts/validate-repository.sh` from the repository root. It checks source-to-package byte parity, local file links, public hygiene, native metadata and versions, stable foundation/stage identifiers, and mutation tests of the copier and validator. It does not execute agent instructions, validate live model availability, rehearse native actor lifecycle or prove compliance with this checklist. Those claims require corresponding review or runtime evidence.
