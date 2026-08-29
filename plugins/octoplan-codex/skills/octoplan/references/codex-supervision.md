# Codex supervision

Read after authorization or resume. Octopad holds durable truth; Codex holds the live run.

## Enter or resume

Start or refresh production Octopad. Read all `Octoplan 18` Decisions, current receipts, open graph and comments, Goal, effective rules, and artifact state. Apply handoff acceptance from [recovery.md](recovery.md) before resuming a Goal.

Continue only while the Brief, reviewed task revisions, review floor, scope, and effects match. Plan drift pauses affected work for review but never revokes consent by itself. For withdrawn authority, an undisclosed or ambiguous effect, or pre-v18 state, pause the affected branch and read [recovery.md](recovery.md).

One supervisor acts, as named in the stream Decision. Reread it before every spawn, effect, close, gate clearance, and Goal transition. Never mutate an unrelated Goal. Set a token budget only when requested.

Every user-facing Delivery contact starts with `**Octoplan · Step 3 of 3 — Delivery**`, then `Position — task N of M · phase · countable outcome unit · decisive metric` for a sequence or `Position — completed/active/total executable · phase · countable outcome unit · decisive metric` for a graph. Quote observed behavior verbatim when behavior is the output. Apply [SKILL.md](../SKILL.md), persist evidence, and use the consequence handoff for every wait.

## Phase 4: advance the ready frontier

Repeat until the integrated outcome is proved or no safe work remains:

1. **Refresh.** Read intent, supervisor, reviewed revisions and lenses, ready graph, assignments, artifact versions, checks, effects, and gates.
2. **Pick.** Choose a ready unassigned task and set it in progress.
3. **Route.** Keep small work inline; spawn only for net benefit and apply the saved route.
4. **Collect.** Put the real deliverable, version, verification, decisions, and blockers on its task.
5. **Review.** Run targeted checks and the delivery floor. Record cleared gates; return stable fixes to the same healthy worker.
6. **Advance.** Close only after current proof and every finding disposition are accepted. Persist evidence, then refresh the frontier.

At resume, worker collection, task close, report, and attempt selection, compare observations with the kill question. An answer stops that run generation immediately; never dispatch onto it, defer it, rename it a stated limit, call it “the design”, remove it through a subset, or average it away. Preserve the result and replan.

Before task close, add one compact supervisor comment that references receipts and names checks, review or checkpoint outcome, material decisions, the countable outcome unit, and the assumption that makes it worthless. Two consecutive closes that advance no unit trigger replan. File or diff size is diagnostic, never a gate. Treat actors, messages, and effects as created only after a returned or authoritative result.

Require exact user-facing strings and surfaces. Put them on an unstarted owner task without changing its specification; replan if that owner started.

Do not mirror a scheduler, Plan page, report, or registry. Tasks and dependencies are graph state; comments carry receipts. The Goal is only a continuity handle. While safe authorized work remains, never end because a turn, tool, or worker ended: persist the next action and continue through the Goal, or make a durable supervisor handoff if native continuation is unavailable.

## Worker prompt

Send a bounded prompt without predecessor history:

```text
Deliver one Octopad task: <task title>.
Octopad: <organization> / <workspace> / <work stream>.
Use <saved model and effort> and the recorded observation rule.

Read this task, stream Decisions, and target rules in production Octopad.
Work only within its authority. Run Verify and write the real artifact version,
output, decisions, blockers, and any user-facing strings on the task.

Do not close, advance, launch, approve, or perform a protected effect.
Return the handoff if needed; otherwise name artifact and verification result.
```

For an errored or unverifiable worker, stop that branch and use [recovery.md](recovery.md). Never finish under another identity.

## Proof and review

Verify the exact artifact version on the task's named proof surface. Repository work refreshes base, head, diff, and checks before mutation, push, review, and handoff. Content, research, and operations use their planning proof lenses; source or test checks never substitute for rendered UI, live API, raw trace, exact database, or source-corpus proof.

Green CI proves only what it ran. An unavailable verifier blocks. Independent review uses one fresh source-first task; reuse it only for stable fixes. Material lens drift gets fresh review.

When tests can bypass production, require negative proof at the real call site.

Only the supervisor validates advancement and authority; other verdicts are evidence.

A reviewer cannot enlarge `Done when`. A finding blocks only on an effective rule, reviewed requirement, uncleared gate, or correctness failure; otherwise record residual risk. Disposition every finding.

Unplanned persistent CI, harness, service, dependency, or cross-repository artifact is scope expansion; reject it or replan when required.

## Phase 5: reconcile change and interruption

Before any protected effect, reread the current task revision, authorization, Plan contract, target, exact head or artifact fingerprint, and effective rules; they must permit exactly this effect now. A mismatch blocks the effect and triggers replan, and a comment cannot waive it. For a duplicable or hard-to-undo effect, also record its `OCTOPLAN_ACTION <stable-key>` per [recovery.md](recovery.md). At a checkpoint or gate, record the subject, owner, and user's continuation.

Consent alone does not refresh a Plan. Classify drift with [planning.md](planning.md), run focused review, and ask for a new go only under [SKILL.md](../SKILL.md). Record drift, affected conclusion, and recheck.

For a timeout, incomplete mutation, worker failure, takeover, or evidence gap, read [recovery.md](recovery.md) before acting. Do not infer success, replay work, or stop independent safe branches.

### Consequence handoff

Wait only for a consequence the user owns, a selected checkpoint, or a person named by an effective rule. Record subject, owner, and continuation. Start with `**Octoplan · Step 3 of 3 — Delivery**`, state the handoff outcome in countable units and the one assumption that would make it worthless, then use these six labels in the user's language:

- **State** — where the outcome stands.
- **Done** — what is finished and proved.
- **Blocked** — what is waiting and why.
- **Decision expected** — the exact human decision or action.
- **To unblock** — who must provide what evidence.
- **Next step** — what resumes immediately afterwards and what safe work continues meanwhile.

Any field may say “none”. A shared-infrastructure disclosure also names the system, event count, duration, and data magnitude. Three task closes or four hours with the same unresolved decision line is a supervisor-owned stall, except person-waits and checkpoints. Unchanged automatic polls are not Goal turns and never justify another user ask. Use native blocked only after the same real impasse persists for three genuine Goal turns with no in-scope progress.

## Phase 6: prove closure or hand off

Choose a fresh supervisor before Goal creation whenever the planning pass was heavy. For a later takeover or incomplete handoff, stop at a safe boundary and follow [recovery.md](recovery.md). Persist in-flight state on its owning tasks; never transfer a Goal or authority through chat alone.

Complete only when the current integrated outcome is proved, Brief and task revisions match PASS, reviews and dispositions are satisfied, every selected checkpoint, Step-by-step pause, and house-rule gate has recorded continuation, effects have receipts or are unnecessary, and no task or ambiguous effect remains active.

Task state, Goal, supervisor Decision, session closure, and final handoff must agree before a clean close; reconcile or disclose tracker drift without making it a gate. Close the outcome task and Goal, release supervisor ownership, and disclose any failed closure call; failure blocks a clean-closure claim. Publish one `**Octoplan · Step 3 of 3 — Delivery**` six-field recap using `built`, `reviewed`, `merged`, `applied`, `verified`, `released`, `accepted`, or a domain equivalent at the real finish line, with residual risks and authorized deferrals.
