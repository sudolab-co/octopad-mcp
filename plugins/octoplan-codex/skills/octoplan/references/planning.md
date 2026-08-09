# Octoplan planning protocol

The dependency graph is executable truth. This reference owns planning workflow, review meanings, feasibility reasoning, and repair classification; exact saved shapes and bytes live only in [octoplan-contract-v3.md](octoplan-contract-v3.md).

## Contents

- [Entry gate](#entry-gate)
- [Context and scoping brief](#context-and-scoping-brief)
- [Execution runway](#execution-runway)
- [Workflow](#workflow)
- [Decisions and graph](#decisions-and-graph)
- [Feasibility](#feasibility)
- [Plan review](#plan-review)
- [Consent binding](#consent-binding)
- [Parallel work and Blueprints](#parallel-work-and-blueprints)
- [Runtime classification](#runtime-classification)
- [Blockers and accounting](#blockers-and-accounting)
- [Saved-state self-check](#saved-state-self-check)

## Entry gate

Read this reference completely for a planning, replanning, or flesh-out pass.

As soon as the scoping brief is complete, read the contract completely before review, feasibility, any draft persistence, fingerprinting, or consent.

Classify the intended result as exactly `greenfield`, `candidate`, `supported`, or `unsupported`. `greenfield` means no candidate, manifest, ledger, or native-creation marker exists; `candidate` means one valid transient root with only its journal-reconciled construction records and no final marker; `supported` means one complete current contract. Every other state is `unsupported`.

Dispatch only the complete supported pair; resume a candidate only through its exact journal. After planning authority and both runway gates, greenfield or a safely quarantined replacement may open one guarded `octoplan-candidate-v1`. It is non-authoritative and resumable. Unsupported history is never mutated. Never infer a field, target, authority, PASS, feasibility, adoption, or consent.

## Context and scoping brief

Retrieve only bounded, decision-relevant context and authoritative source pointers needed to prove the graph. Make one cursor-advancing discovery pass and at most one targeted gap refill; never repeat the same target, cursor, and revision without a new failed predicate.

Read the stream's governing Decisions, Questions, tasks, graph edges, tracker, and required source records. Resolve people from current members and roles.

Ask only questions that can change result, scope, risk, order, proof, owner, validation timing, stream choice, project, or native-task authority. Ask every currently material question in one numbered batch; allow one targeted follow-up batch only when answers reveal new material uncertainty.

On the default path, the first reply on every full pass is the whole scoping brief: Understanding; In scope / out of scope including the nearest excluded result; Success; Assumptions with verified basis; Open questions; Execution outlook with stream/project, foreseeable blockers, missing capabilities or prerequisites, and native-task authority; Validation mode (`gradual` or `final`); Delivery mode; and a one-line authority summary.

When native actors may be needed, ask in the first brief for one exact grant covering the named project, allowed environments, and finite roles. It covers later agent-owned creates only for the validated plan; never ask per actor. Delivery mode or consent never supplies it.

On the default path, do not write a plan or create an execution session before confirmation. A reply that answers every numbered question and accepts the Delivery mode confirms unchanged brief fields; publish the resolved brief as a non-blocking receipt and do not ask for a second confirmation. A material delta is the only reason to ask again. Valid explicit-no-loop instead publishes a non-blocking checkpoint and may continue under the exact initial grant.

Use the user-facing labels from the contract. Default to **Review before delivery**. An initial **Autonomous delivery** request, or semantically equivalent end-to-end delegation in any language, may activate the contract's explicit-no-loop path when the instruction unambiguously covers finding the plan, executing it, and adapting it inside a complete outcome envelope.

A later brief-only confirmation grants no execution authority. A bare “do it”, urgency, trust without delivery delegation, prior conversation, or permission to plan never supplies the missing grant.

The explicit no-loop path is valid only when the initial request already contains that explicit grant, a complete outcome envelope, no unresolved material point, no scope-expanding inference, and separate protected occurrences.

For that path, publish the brief as a non-blocking checkpoint, record the exact source, and continue through durable Decision persistence. Once durable Decision IDs make the complete canonical mandate available, obtain a fresh independent activation review before Plan PASS, fingerprinting, consent, or launch; no execution session precedes it.

If a material answer remains open after the follow-up batch, return one `HUMAN_DECISION` with options and a recommendation instead of serial questioning. Save the Question and affected flesh-out placeholders only after both runway gates pass in the final planning task.

## Execution runway

Run two gates. The substrate gate comes first: prove native project identity, one project and stream action (`reuse|create`), creation/reconciliation, Octopad planning access, one fresh read-only review subagent, and one exact source authorizing the finite native roles. The source stays provisional until its grant binds the final plan hash. Evaluate it before research or drafting. Paths, prompts, names, Delivery mode, and consent prove neither identity nor creation authority.

If the current task already has the exact intended project identity, continue. If it has a null, projectless, or different identity while execution needs a saved project, do not write Decisions, tasks, trackers, manifests, claims, quarantine records, or migration notes. Resolve one exact saved project from the native registry. Ambiguity asks one material question. Missing substrate gets one bounded self-repair attempt, then a pre-write handoff with the exact failed predicate.

With relocation authority, the source task owns one bootstrap. Its `OCTOPLAN_BOOTSTRAP` identity binds brief digest, full target, stream action, and separate native-creation and relocation authority sources/digests. Read registry and durable source transcript first. Emit one exact `OCTOPLAN_BOOTSTRAP_INTENT` before, then create only in that uninterrupted turn. On crash, timeout, lost response, delayed listing, or grant change, its presence means `issued-or-ambiguous`: adopt one exact match, pause on several, and with zero stay pending then pause; it never permits another create. A `clientThreadId` is only a setup handle. Nonterminal unavailable/null identity waits without activation or create. The child never relocates itself, creates a replacement, or remains an actor.

Native metadata alone classifies `verified-project`, `verified-projectless`, or `verified-null`; missing, malformed, timed-out, or conflicting evidence is `unavailable`, never null. Only ready/terminal verified null permits one persisted repair intent and handoff to `local`. Persist `operationId`, await terminal success, and adopt only `destinationThreadId`; source and setup IDs never qualify. Error, timeout, changed/missing destination, unavailable/wrong/null-after-repair identity, or multiple matches pauses with the six-field handoff and repeats nothing. The bootstrap makes no Octopad write or claim and restarts the runway only after destination identity matches. Review before delivery requests confirmation and both authorities together; Autonomous delivery requires both in its initial source.

Only the relocated task's verified native metadata becomes the planning target. If native relocation is unavailable, report the blocker before durable planning.

After drafting, the persistence gate validates schemas, writes, sources, prerequisites, and verifiers. Decision, Question, and task proof is schema `octopad-direct-readback-v1` from raw MCP `CallToolResult.structuredContent`; if the host hides it, accept only JSON after `OCTOPAD_DIRECT_READBACK`. Markdown, `_ui`, or missing/duplicate/wrong-type items never substitute. Stream create supplies `scope` and `work_stream_description`; streamed tasks omit `goal_id`; write `page_ids` uses `{page_id,rationale}`. Match every operation key, ID, and canonical payload digest. A missing, duplicate, or failed receipt prevents cursor advance and sealing unless exact readback proves that item: direct-read successful IDs, then issue only still-missing writes under their original journal keys, never the whole batch. Rebuild off-record before one journaled attempt; create a stream once and pass its ID to every actor.

## Workflow

1. **Brief and gates.** Classify the entry, batch the brief's material questions, follow **Reflect or branch**, and prove or relocate the substrate. Build the graph off-record, then pass the persistence gate.
2. **Draft and prove.** Resolve the stream, sources, success, owners, gates, choices, and graph. Reconfirm the relocated planning target and capability topology. Give every task one deliverable, owner, route, proof, repair envelope, and human gates; keep probes internal. Build bijective feasibility coverage and simulate the first and highest-risk frontiers.
3. **Challenge off-record.** Start one fresh read-only Codex subagent with the draft and evidence. It returns provisional findings only; retain it for the final subject and add a specialist only for an orthogonal material risk.
4. **Construct and bind.** Open or resume the candidate, rebuild and verify its immutable write set, reconcile its guarded cursor, persist and reread the complete graph, and normalize IDs. Build the canonical review subject, excluding only its future attestation envelope, and have the same subagent return one immutable artifact over that digest. The planner adds the envelope and conditional equality, then rereads and mechanically validates the whole candidate. Compute v3 bytes with the two hash fields normalized, guardedly replace the root with the complete final pair, reread and recompute it, and require `supported`. A crash resumes the journal; mismatch stays unsealed.
5. **Consent.** Follow the runtime's exact plan-bound or outcome-bound path. A failed guarded binding writes no authority.

## Decisions and graph

Material scope, success, risk, validation, ownership, and route choices are Decisions or Questions, never hidden assumptions. Each task produces one independently deliverable result. Merge steps with the same owner, artifact, route, verifier, and human gate unless each has independent acceptance; keep planning, preflight, reads, review, tracker maintenance, and status relay internal. Preserve protected human occurrences as separate tasks. Remove a transitive dependency only when its alternate path subsumes the same rationale and gate; graph reachability alone is insufficient. Use literal Why/What and top-level Done when, numeric impact 1–5 with rationale, and dependency rationales.

Delivery ends at a review-ready artifact. Keep every human or protected action separate. Save routes, bounds, same-project targets, role capabilities, and verification needed by a fresh executor; every packet names organization, workspace, and task. Persist the contract records guardedly; Blueprint and tracker summaries never replace them.

## Feasibility

Build coverage and the matrix exactly as the contract defines. Every triggered invariant needs an available primitive, source, boundary, compensation, verifier, and prerequisites; missing proof never yields prose PASS. An empty matrix passes only when every coverage record has empty `triggered_invariants`. Bind its digest, critical revisions, and verifier availability to review, then recheck before launch and after relevant change.

## Plan review

`PASS` is composite: the read-only artifact attests the contract's canonical review-subject digest, while guarded readback mechanically validates its detached envelope and proves final saved equality with current sources, verifiers, and mandate. The reviewer also challenges orchestration overhead, repeated homogeneous tasks, internal-step tasks, and redundant edges. A reviewer verdict alone is never Plan PASS. `REVISE` is correctable; `INFEASIBLE` proves no authorized route; `HUMAN_DECISION` needs human authority or choice.

The reviewer cannot persist, claim, or launch. The planner persists its exact artifact, routes, reviewed and matrix digests, source/verifier and mandate results, and conditional equality in the final candidate. Exact full readback makes equality effective without recursively reviewing the attestation envelope. Any subject, source, verifier, matrix, mandate, adoption, or conformance change needs fresh review; any envelope or equality change invalidates sealing and binding.

## Consent binding

`plan-bound` needs later exact-final-hash consent unless brief confirmation explicitly grants launch after verification. `outcome-bound` needs plan, launch, and material-replan authority; its mandate, unlike its launch binding, stays byte-identical across eligible replans. Before launch, guardedly append the contract binding outside the fingerprint.

A material replan invalidates the old launch binding in either mode. The replacement needs fresh feasibility, adoption mapping, source/read-back equality, v3 fingerprint, and independent conformance PASS before a new run; no old PASS or consent transfers.

## Parallel work and Blueprints

Parallel members share a readiness frontier and no file, symbol, contract, artifact, structure, migration, lockfile, or scarce resource. Persist symmetric safety by immutable ID and activate the whole group atomically; otherwise serialize before persistence. Multi-stream work exposes seams/owners, confirms each stream brief, and graphs cross-stream dependencies. Blueprints explain but never enforce.

## Runtime classification

The plan encodes repair, follow-up, and replan bounds; runtime may not expand them. Repair preserves the reviewed result and protected boundary. Follow-ups stay outside the run. A material or ambiguous change follows the runtime's replan authority.

## Blockers and accounting

Persist the stable blocker key before rerouting; wording, replacement, or irrelevant artifacts do not reset it. After two recurrences without new satisfiability evidence, prove a materially different route or return `HUMAN_DECISION`, `waiting-human`, `paused`, or independent `INFEASIBLE`.

Record authoritative actuals only; missing time/cost is null/unavailable and provider cost is never estimated. Compare numeric bounds only in matching canonical units; otherwise require fresh conformance judgment and use `HUMAN_DECISION`/`waiting-human` when authority may change.

## Saved-state self-check

Before Plan PASS, validate the exact readback against the contract; any failed predicate leaves the candidate unsealed.
