# Octoplan contract v3

This is the only normative source for saved schemas, durable fields, extraction, canonical bytes, and contract fixtures. It is read after a complete scoping brief and before review, feasibility, persistence, fingerprinting, consent, launch, or resume.

## Contents

- [Supported contract and gate](#supported-contract-and-gate)
- [Delivery mode](#delivery-mode)
- [Brief, activation, and review](#brief-activation-and-review)
- [Manifest and saved collections](#manifest-and-saved-collections)
- [Targets and parsing](#targets-and-parsing)
- [Tasks, Questions, and protected occurrences](#tasks-questions-and-protected-occurrences)
- [Feasibility and blocker identity](#feasibility-and-blocker-identity)
- [Run state, adoption, and accounting](#run-state-adoption-and-accounting)
- [Fingerprint input and exclusions](#fingerprint-input-and-exclusions)
- [Extraction and canonicalization](#extraction-and-canonicalization)
- [Native creation](#native-creation)

## Supported contract and gate

The final saved pair is exactly one `octoplan-supervision-v6`, one `octoplan-fingerprint-v3`, one canonical `delivery_mandate`, and one `native_creation_schema` equal to `octoplan-native-creation-v3`. A missing, duplicate, hybrid, changed, malformed, unknown, extra, or missing final element fails closed before execution routing, consent, resume, or a native actor. A plan carrying the old native creation contract is unsupported and must be replanned. Never infer authority, PASS, feasibility, adoption, or consent.

Before a greenfield or safely fenced replacement has that pair, exactly one transient `octoplan-candidate-v1` root may exist. It contains only `schema`, non-empty `candidate_id`, lowercase SHA-256 `brief_digest`, `authority_message_digest`, exact `target`, `stream_action` (`reuse|create`), `write_set_digest`, nonnegative `journal_cursor`, and `phase` (`assembling|ready-to-seal|abandoned`). It is opened only after confirmed planning authority and both runway gates. The guarded root is the durable journal carrier: rebuild the immutable ordered write set, require its digest to equal `write_set_digest`, key operation `i` as `<candidate_id>:<i>`, read it back, then advance `journal_cursor` from `i` to `i+1` under the same guard. Resume reconciles every earlier key and the current key before writing; a different write set can only abandon the candidate. Its journal-reconciled construction records are candidate state, not conflicting contract markers. It grants no execution authority, native actor, consent, protected action, or PASS. A guarded seal computes the normalized v3 hash, replaces the root with the complete final pair, then rereads and recomputes it; abandonment keeps a read-only quarantine pointer. Any other partial state is unsupported, never greenfield.

The v6 Plan manifest is enclosed by exactly one `OCTOPLAN_PLAN_MANIFEST_V6_BEGIN` and `OCTOPLAN_PLAN_MANIFEST_V6_END` pair. Markers must be ordered, non-nested, unique, and removed from the fingerprint as one byte range: from the begin-marker line's first byte through the end-marker line's LF, or EOF when final.

## Delivery mode

User-facing replies call this choice **Delivery mode** and use only these labels:

- **Review before delivery** maps to the internal wire value `plan-bound`: show the brief, wait for confirmation, and obtain the required execution or replan consent.
- **Autonomous delivery** maps to `outcome-bound`: own planning, independent review, launch, and in-envelope replanning; ask only for an unresolved material decision, an out-of-envelope change, or a protected occurrence.

The wire values and `delivery_mandate` field name are internal and never appear in user-visible prose. A user may select a label explicitly or express the same intent naturally in any language.

Persist exactly this object in the Plan manifest and v3 fingerprint; object keys and array values are canonicalized below, and the object is immutable after binding:

```json
{
  "schema": "octoplan-delivery-mandate-v2",
  "mode": "plan-bound|outcome-bound",
  "activation_kind": "confirmed-brief|explicit-no-loop",
  "scoping_brief_digest": "<lowercase SHA-256>",
  "frozen_decision_ids": ["<sorted immutable Decision ID>"],
  "allowed_delta_classes": ["<sorted covered class>"],
  "authority_source": {
    "record_id": "<durable source record ID>",
    "message_digest": "<lowercase SHA-256>"
  },
  "policy_sources": [
    {"kind": "<host|organization|repository|service>", "locator": "<stable locator>", "revision": "<immutable revision or null>"}
  ],
  "protected_actions_authorized": false
}
```

`scoping_brief_digest` hashes the brief's exact UTF-8 bytes after CRLF/CR-to-LF conversion; `authority_source.message_digest` applies the same rule to the exact authorizing user message. Do not trim or Unicode-normalize either source, and reject unpaired surrogates before encoding. Require lowercase hexadecimal, unique sorted Decision IDs and delta classes, known policy kinds, and JSON `false` exactly for protected actions. `plan-bound` requires `confirmed-brief` and an empty delta-class list. `outcome-bound` accepts either activation kind and only explicitly covered delta classes. No mandate field grants a protected action.

The four allowed delta classes are exactly `artifact-lineage`, `implementation-approach`, `route`, and `task-graph`.

## Brief, activation, and review

On the default path, the initial reply is only the mandatory scoping brief: understanding, explicit in/out scope including the nearest excluded result, success, verified assumptions, one batch of open questions, Execution outlook with stream/project, blockers, missing prerequisites/capabilities and native-task authority, validation mode (`gradual|final`), Delivery mode, and authority summary. It contains no planning write or execution action; valid explicit-no-loop publishes it as a non-blocking checkpoint.

On the default path, a later reply confirms the whole brief before a candidate write. Answering every numbered question and accepting Delivery mode confirms unchanged fields; only a material delta asks again. Brief confirmation alone grants no execution. The explicit-no-loop checkpoint is the only non-blocking exception. Natural language activates `outcome-bound` only when it unambiguously delegates planning, execution, and in-envelope adaptation for a bounded outcome; “do it”, urgency, trust, or an unbounded request is insufficient. Host policy may still require explicit user-owned native-task creation authority, which the brief obtains once before the candidate.

For explicit no-loop activation, publish the checkpoint, record its exact source, resolve every material question without scope-expanding inference, and keep protected occurrences separate. Once durable Decision IDs make the mandate available, the fresh read-only pre-run subagent uses `plan-reviewer` without a run, stream, task, or supervisor identity and returns the independent activation-review artifact; the planner alone persists it before Plan PASS, fingerprinting, consent, or launch. No execution actor precedes it. Persist exactly one `activation_review`, fingerprint it, and repeat its `record_id` and `evidence_digest` in the launch binding. It is JSON `null` for `confirmed-brief`; otherwise it has exactly `record_id`, `brief_digest`, `mandate_digest`, `evidence_digest`, and literal `verdict: "PASS"`.

The only valid mode/activation combinations are `plan-bound` plus `confirmed-brief`, `outcome-bound` plus `confirmed-brief`, and `outcome-bound` plus `explicit-no-loop`. The exact review-verdict list is `PASS`, `REVISE`, `INFEASIBLE`, and `HUMAN_DECISION`; meanings are defined only in planning.

## Manifest and saved collections

The manifest contains the exact v6 supervision policy, execution targets, mandate, activation review, feasibility coverage and matrix, critical source revisions, verifier availability, adoption map, Plan review, and the coordination ledger task ID. The canonical input also contains `protected_occurrences` extracted from durable human occurrence records. Its structured values are represented by this fingerprint input shape; no rendered prose substitutes for a durable value:

```json
{
  "fingerprint_schema": "octoplan-fingerprint-v3",
  "ledger_task_id": "<immutable ledger task ID>",
  "plan_hash": "PENDING",
  "manifest": {
    "native_creation_schema": "octoplan-native-creation-v3",
    "supervision_contract": {
      "schema": "octoplan-supervision-v6",
      "policy": "<exact Policy value>",
      "validation_mode": "<gradual|final>",
      "repair_envelope": "<exact value>",
      "follow_up_policy": "<exact value>",
      "inline_route": "<exact value>",
      "dedicated_route": "<exact value or null>",
      "dedicated_replacement": "<exact value or null>",
      "default_recovery": "<exact value>",
      "default_lineage": "<exact value>",
      "run_states": ["active", "replanning", "waiting-human", "paused", "revoked", "superseded", "failed", "completed"],
      "review_verdicts": ["PASS", "REVISE", "INFEASIBLE", "HUMAN_DECISION"]
    },
    "execution_environment": {
      "inline_supervisor_target": {"kind": "<project|projectless>", "project_id": "<ID or null>", "environment": "<local|worktree or null>", "directory_name": "<name or null>", "rationale": "<rationale or null>"},
      "dedicated_supervisor_target": "<same target object or null>",
      "default_executor_target": "<same target object>",
      "task_role_target_overrides": [{"task_id":"<non-empty string>","role":"<planner|executor|lead-reviewer|specialist-reviewer|recovery>","target":{"kind":"<project|projectless>","project_id":"<ID or null>","environment":"<local|worktree or null>","directory_name":"<name or null>","rationale":"<rationale or null>"}}],
      "reviewer_default": {"kind": "<project|projectless>", "project_id": "<ID or null>", "environment": "<local|worktree or null>", "directory_name": "<name or null>", "rationale": "<rationale or null>"}
    },
    "delivery_mandate": "<exact object above>",
    "activation_review": "<exact object above or null>",
    "feasibility_coverage": ["<exact coverage record>"],
    "feasibility_matrix": ["<exact matrix row>"],
    "feasibility_matrix_digest": "<lowercase SHA-256>",
    "critical_source_revisions": ["<sorted immutable revision>"],
    "verifier_availability": ["<exact verifier and boolean>"],
    "adoption_map": ["<exact adoption row>"],
    "adoption_map_digest": "<lowercase SHA-256>",
    "plan_review": {"reviewed_draft_digest": "<digest>", "feasibility_matrix_digest": "<digest>", "lead": "<literal Lead line>", "specialist": "<literal Specialist line or null>", "verdict": "<verdict>", "mandate_conformance": "<PASS|REVISE|HUMAN_DECISION>", "review_pass": "<literal matching Review PASS record>", "final_binding": {"plan_hash": "PENDING", "saved_state_equality": true, "critical_sources_and_verifiers": "PASS"}}
  },
  "streams": ["<stream>"],
  "decisions": ["<Decision>"],
  "questions": ["<Question>"],
  "tasks": ["<agent or human task>"],
  "protected_occurrences": ["<exact protected occurrence>"]
}
```

`plan_hash` at the fingerprint root and `manifest.plan_review.final_binding.plan_hash` are normalized to `PENDING` before hashing. `reviewed_draft_digest` is the lowercase SHA-256 of a separate canonical review subject: start from the complete normalized candidate fingerprint input, remove exactly the one `manifest.plan_review` property as the detached attestation envelope, and hash the remaining canonical bytes. Nothing else is excluded. The reviewer attests those bytes once. The planner then validates the artifact digest and verdict mechanically, adds the exact `plan_review` envelope with conditional equality already true, and rereads the complete candidate. Equality becomes effective only on byte-identical full readback, never by a later toggle. A review-subject, source, verifier, matrix, adoption map, or mandate change requires fresh review; an attestation-envelope or equality change invalidates seal and binding without recursively reviewing that envelope.

The manifest's supervision contract is read from the durable task text, not a generated summary. Each required label occurs once, and its value includes all source whitespace after the prefix. The dedicated route and dedicated replacement labels alone accept literal `none`; an empty value is malformed.

Extract `native_creation_schema` as a required manifest value, fingerprint it, and reject anything other than `octoplan-native-creation-v3` before routing or resume. This is the migration fence for plans created under the old native identity.

The active planning session's resolved native target is the planning target and is saved as `inline_supervisor_target`; never replace it from prose or a later caller's directory. A pre-planning relocation may select a saved project only before any Octopad planning write, using the exact user-confirmed target or an unambiguous target inside valid autonomous authority. The bootstrap session is outside this saved contract, performs no Octoplan write, and cannot remain an actor; the relocated task must restart preflight, and only its verified native metadata may become the planning target. Every other target must share that Codex project identity. Resolve project targets through the current registry and retain host, path, and Git observations only as excluded evidence. A projectless target must state why it is safe. Role targets require native capability; analytical delegation has no launch authority.

The exact Plan-review envelope contains the canonical review-subject digest, matrix digest, lead route, optional specialist route, verdict, mandate-conformance verdict, matching immutable review artifact, `PENDING` plan hash, conditional saved-state equality, and source/verifier PASS. Mechanically require the artifact's subject digest, evidence digest, and verdict to match that envelope. Reviewer verdict alone is not Plan PASS: the planner persists the complete candidate once, rereads exact equality, computes the normalized hash, atomically seals to the final pair, then rereads the final pair and recomputes the same hash. Consent, binding, and native creation require that sealed readback to classify as `supported`.

The activation review is fingerprinted as the exact object and its launch binding repeats only its record ID and evidence digest. The mandate digest used there covers the complete canonical mandate, not a selected subset. A changed activation record, evidence digest, or mandate invalidates the binding.

For `activation_review`, `brief_digest` must equal `delivery_mandate.scoping_brief_digest`, `mandate_digest` must equal the SHA-256 of the complete canonical mandate object, and `evidence_digest` must equal the SHA-256 of the exact review-record text after LF normalization, with no trim or Unicode normalization. Validate all three equalities, not merely field presence.

The saved source set contains every participating stream, Decision, Question, task, dependency, route, target, feasibility record, adoption row, protected occurrence, review record, and manifest value required by this contract. Generated runtime records are excluded only where the exclusion section names them.

### Stream and Decision records

Each stream record is exactly `id`, `title`, and `tracker_text`; `tracker_text` excludes its generated supervision pointer but preserves all other bytes. Each Decision record is exactly:

```json
{"id":"<ID>","work_stream_id":"<ID or null>","title":"<exact title>","content":"<direct value or null>","rationale":"<direct value or null>","status":"<exact durable status>"}
```

Missing direct content is `null`, not a rendered fallback. A missing or duplicate Decision ID, field, or durable status fails closed. Decision order is persisted order before canonical collection sorting.

### Question and task records

Each Question is exactly `id`, `work_stream_id`, `question`, `status`, and `answer`. `work_stream_id` and `answer` are `null` when absent; status is never inferred from open prose. Questions are fingerprinted because an unresolved Question gates authority.

Each task is exactly `id`, `work_stream_id`, `parent_task_id`, `title`, `description`, `dependencies`, `assignment`, `impact`, `impact_rationale`, and `routes`. A dependency is exactly `id` plus `rationale`; a route map is the saved route lines and `parallel_safe_with`. Greenfield construction resolves exactly one stream by reuse or one-time creation before sealing; every native role packet requires its non-empty stream ID.

The route scalars are `exec`, `review`, `review_route`, `specialist_review_route`, `fallback`, `recovery_override`, and `lineage_override`. `exec` and `review` are required for an agent task. A human task has null for all seven scalars and an empty parallel list; any mixed shape fails. A planner or recovery incident uses the affected task's saved `recovery_override`, `fallback`, or default recovery route; it never invents a route.

### Feasibility and adoption records

Each coverage record is exactly `task_id` plus `triggered_invariants`; each triggered invariant is exactly `invariant_id` plus `trigger_class`, and the class is one of the nine declared classes. Every agent or human task has one coverage record. The `(task_id, invariant_id)` key is unique. Coverage and matrix collections are bijective: every triggered invariant has exactly one matrix row with the same task, invariant, and class, and every matrix row has exactly one coverage item. The matrix is empty if and only if every `triggered_invariants` list is empty; missing coverage is not equivalent to an empty list.

Each feasibility row is exactly:

```json
{"task_id":"<ID>","invariant_id":"<invariant ID>","trigger_class":"<class>","primitive_ref":"<primitive>","source_revisions":["<revision>"],"consistency_boundary":"<boundary>","rollback_or_compensation":"<path>","verifier":"<exact verifier>","verifier_available":true,"prerequisite_task_ids":["<ID>"]}
```

Each verifier record is exactly `verifier` and `available`. Each adoption row is exactly the nine fields named in the adoption section, including explicit invalidated evidence and PASS lists and a literal fresh conformance PASS.

Each adoption key `(old_run_id, source_task_id, artifact_revision)` is unique. The same artifact revision cannot be mapped twice, and a PASS listed as invalidated cannot be omitted from the row. A carried artifact without a destination or lineage is rejected rather than guessed.

### Launch binding and actuals

The runtime launch binding is the contract-defined guarded ledger record containing the exact authority source record and message digest, brief digest, final plan hash, matching review PASS, saved-state equality PASS, mandate-conformance PASS, matrix digest, critical source/verifier result, activation-review reference when applicable, and no-material-delta assertion. It has no separate source-time authority field.

The binding is runtime evidence, never a second manifest mandate and never a second fingerprinted plan-hash field. A failed guarded write does not authorize launch. Revocation or narrowing fences the run immediately.

Actual accounting records the source record and canonical units with each available actual. Missing actuals use null or the explicit unavailable marker; provider cost is not calculated from tokens, time, price lists, or a guessed rate.

### Contract rejection boundaries

Reject self-referential final hashes, duplicate IDs, duplicate object keys, duplicate route bindings, malformed targets, a target outside the planning target's Codex project identity, missing source revisions, unavailable verifiers, omitted trigger coverage, ambiguous adoption, a non-PASS adoption row, and any attempt to reuse a prior PASS after a fingerprinted change.

## Targets and parsing

Persist targets as exactly five keys: `kind`, `project_id`, `environment`, `directory_name`, and `rationale`. A project target is the label value `<project ID> · <local|worktree> · <observed evidence>` on `Project target:`; split only on the first two literal ` · ` separators, require non-empty project ID and a valid environment, and retain the complete remainder, including any separators, as excluded observed evidence. Its canonical object has `kind: "project"`, project ID, environment, and JSON `null` for directory and rationale.

A projectless target is the label value `projectless · <directory> · <rationale>` on `Projectless target:`; split only on the first two literal ` · ` separators, require the literal `projectless`, a valid non-empty directory, and a non-empty remainder, including separators, as exact rationale. Its canonical object has `kind: "projectless"`, `project_id` and `environment` as JSON `null`, and exact directory and rationale. Do not infer either target kind or any missing field.

Two project targets have the same Codex project identity only when both `kind` values are `project` and their exact `project_id` values match; `environment` may differ between `local` and `worktree`. Two projectless targets match only when both `kind` values are `projectless` and their exact `directory_name` values match. A project/projectless pair never matches.

Persist the planning target as the one `Inline supervisor target`, plus one `Default executor target` and one `Reviewer default`; each is an exact canonical five-key target object. `Dedicated supervisor target: none` maps only to JSON `null`. The dedicated supervisor, default executor, reviewer default, and every task-role override must share the inline planning target's Codex project identity. Each task-role override is exactly `{task_id: non-empty string, role: planner|executor|lead-reviewer|specialist-reviewer|recovery, target: exact canonical five-key target object}`; no extra or missing key is allowed. Overrides are unique by `(task_id, role)` and sort by task ID then role. `Task-role target overrides: none` maps only to `[]`. Missing, empty, unknown-role, malformed, duplicate, or cross-project bindings stop fingerprinting.

A planner uses its task-role target override when present and otherwise the inline supervisor target. Its role packet carries the exact selected model, effort, capability rationale, and incident route; a capacity change produces a reviewed delta and a fresh creation identity.

When no task override exists, the supervision contract's `Default recovery` is the incident route. The route, model, effort, and capability profile are bound in the native creation identity, not selected from caller context.

`capacity_source` is exactly `{"kind":"saved-route|incident-delta","record_id":"<non-empty>","evidence_digest":"<lowercase SHA-256>"}`. The packet's model and effort are read from that source record. `saved-route` uses the selected saved recovery/default route; `incident-delta` requires the reviewed delta's record and digest. A missing, stale, or unreviewed source stops creation.

## Tasks, Questions, and protected occurrences

The canonical Decision is `id`, `work_stream_id`, `title`, `content`, `rationale`, and uses durable `status` directly; absent `work_stream_id`, `content`, or `rationale` is JSON `null`. The `content` value is the exact direct value when exposed. Never compose a value from rendered prose. The canonical Question is `id`, `work_stream_id`, `question`, `status`, and `answer`; absent work-stream or answer is JSON `null`, while status is the exact authoritative readable value.

Every saved task has direct `id`, `work_stream_id`, `parent_task_id`, `title`, `description`, `dependencies`, `assignment`, `impact`, `impact_rationale`, and `routes`. Nullable scalars are JSON `null`; absent or inapplicable lists are `[]`. An agent task requires literal `Exec` and `Review` routes. A human task has JSON `null` for every route scalar and `[]` for `parallel_safe_with`; its owner stays in `assignment`. Optional route values are exact literals or JSON `null`, never invented. `impact` is the saved JSON number 1 through 5, never a string, fraction, or default. Dependency entries retain their paired rationales, and duplicate task, dependency, or parallel IDs fail closed.

Every protected human occurrence is exactly:

```json
{"task_id":"<non-empty human-task ID>","action_kind":"merge|migration-application|deployment|publication|access-grant|external-spend|destructive-effect|acceptance","target":"<non-empty string>","parameters":{},"environment":"<non-empty string or null>","amount_currency":null,"audience":"<non-empty string or null>","occurrence_key":"<non-empty globally unique string>","owner_approval_rule":"<non-empty string>","evidence":"<non-empty string>","wake_predicate":"<non-empty string>"}
```

`parameters` is an exact JSON object, including `{}`; `environment` and `audience` are non-empty strings or JSON `null`, but publication requires a non-null audience. `amount_currency` is JSON `null` except for external-spend, where it is exactly `{amount: non-empty canonical decimal string, currency: non-empty unit string}`. Every occurrence points to a human task, every protected human task has exactly one occurrence, no agent task is referenced, and occurrences sort by `occurrence_key`; nested parameters use the global object-key rule. Merge, migration application, deployment, publication, access grant, external spend, destructive effect, and acceptance remain separate occurrences; the mandate's `false` value cannot satisfy or remove one.

Blueprint pages are explanatory only. They are excluded from the fingerprint and cannot be the sole source for launch, cutover, success, dependency, gate, or finish-condition logic; those facts live in Decisions, Questions, tasks, or graph edges.

## Feasibility and blocker identity

Create one feasibility coverage record per agent or human task using exactly the trigger classes in this contract. Every triggered class maps to exactly one matrix row, and every matrix row maps back to exactly one task/invariant pair. An empty matrix can PASS only when every coverage record has an empty `triggered_invariants`.

Each matrix row records the task, invariant, available primitive, source revisions, consistency boundary, rollback or compensation, exact verifier, current availability, and prerequisite tasks. Missing primitive, source, boundary, prerequisite, or verifier yields `REVISE`, `INFEASIBLE`, or `HUMAN_DECISION`, never prose PASS. Bind the matrix digest to Plan review, critical source revisions, and verifier availability, then simulate the first ready frontier and highest-risk path.

The trigger classes are exactly `atomicity-concurrency`, `authorization-access`, `paid-resource`, `destructive-irreversible`, `external-side-effect`, `cross-system-consistency`, `migration-schema`, `security-privacy`, and `production-publication`.

Stable blocker identity uses `source_task_id`, `reason_enum`, `affected_invariant_id`, `prerequisite_or_human_task_id`, `external_resource_locator`, `policy_gate_locator`, and `normalized_bound_values`. `reason_enum` is one of `missing-primitive`, `verifier-unavailable`, `missing-prerequisite`, `infeasible-invariant`, `human-gate`, `policy-gate`, `external-resource`, or `bound-exhausted`. Rewording does not change the key; after two recurrences without new satisfiability evidence, the next plan rejects the route and proves a materially different path.

## Run state, adoption, and accounting

The v6 durable run states are exactly `active`, `replanning`, `waiting-human`, `paused`, `revoked`, `superseded`, `failed`, and `completed`; their authority meanings are defined in supervision. Review verdicts never substitute for run states. `failed` requires an independent `INFEASIBLE`; `completed` requires the fenced supervisor and all required validation and human occurrences.

An adoption row has `old_run_id`, `old_plan_hash`, `source_task_id`, `artifact_revision`, `destination_task_id`, `destination_lineage`, `invalidated_evidence_ids`, `invalidated_pass_ids`, and literal `fresh_conformance_pass: "PASS"`. Every old artifact is explicitly adopted or rejected, every invalidated PASS is listed, and no artifact revision is mapped twice.

Record authoritative actuals only. Unavailable time or provider cost is `null`/unavailable; never estimate provider cost or create a synthetic counter. Compare a frozen numeric boundary mechanically only when both the boundary and authoritative actual use the same canonical units. Otherwise obtain a fresh independent mandate-conformance judgment; ambiguity that could alter authority produces `HUMAN_DECISION` and `waiting-human`.

## Fingerprint input and exclusions

The v3 input is the complete normalized object above, built only from the current v6 manifest and saved authoritative sources. Remove exactly one full LF-terminated tracker line matching `Supervision: octoplan-supervision-v6 · ledger <ID> · plan <64 lowercase hex>` from every tracker; zero or multiple matches stop. Keep every other tracker byte. Exclude all ledger comments, with a launch-binding comment removed as one complete record and never by prose splicing.

Exclude only generated execution/task runtime statuses and claim owners, current supervision mode, observed host/path/Git evidence, claims, attempts, thread IDs, consent evidence, repairs, event receipts, and out-of-run follow-ups. Retain durable `Decision.status`, `Question.status`, and task `assignment`. Scan every included JSON string after exclusion; if the persisted digest remains anywhere, stop instead of hashing a self-reference.

## Extraction and canonicalization

Normalize source line endings to LF before extraction only. Do not trim, otherwise normalize source text, or normalize Unicode. Reject unpaired surrogates. Extract direct durable values, never synthetic rendered text.

For supervision, read exactly one value after each unique `- <Label>: ` prefix for `Schema`, `Policy`, `Validation mode`, `Repair envelope`, `Follow-up policy`, `Inline route`, `Dedicated route`, `Dedicated replacement`, `Default recovery`, and `Default lineage`. Require the schema value `octoplan-supervision-v6`; literal `none` maps to JSON `null` only for the two dedicated labels. The coordination ledger label feeds only root `ledger_task_id`; run-state and verdict arrays use the exact declared order.

For execution, extract exactly one inline target, dedicated target, default executor target, reviewer default target, and every singular task-role override. Parse each non-null value with the target grammar above, require every session target to share the inline planning target's Codex project identity, and apply only the stated `none` defaults. For Plan review, extract unique `Reviewed draft digest`, `Feasibility matrix digest`, `Lead`, `Verdict`, `Mandate conformance`, `Review PASS`, `Plan hash`, `Saved-state equality`, and `Critical sources and verifiers`; absent `Specialist` is JSON `null`, all other missing or duplicate labels stop. Normalize Plan hash to `PENDING`, encode saved equality as `true` only for literal `PASS`, and require critical sources/verifiers `PASS`.

For Decisions, Questions, tasks, routes, coverage, matrix rows, adoption rows, protected occurrences, trackers, and manifest sentinels, require exactly the direct shapes above. Extract each Decision's direct `content`, `rationale`, `work_stream_id`, and durable `status`, defaulting only absent nullable values to JSON `null`; extract every agent and human task field directly, with absent lists as `[]`, human route scalars as `null`, optional agent route values as their exact literal or `null`, numeric `impact` as the saved JSON number 1 through 5, paired dependency rationales, and the exact protected-occurrence fields. Preserve `triggered_invariants` lists and every non-semantic sequence exactly as persisted.

Sort object keys by Unicode scalar order over unescaped names. Sort streams, decisions, questions, and tasks by immutable ID; dependencies and `parallel_safe_with` by immutable ID; target overrides by task ID then role; protected occurrences by `occurrence_key`; adoption rows by old run, source task, then artifact revision; coverage and feasibility rows by task ID then invariant ID; each `triggered_invariants` list by invariant ID then trigger class. Sort source revisions, prerequisites, critical sources, frozen decisions, delta classes, and invalidated IDs by Unicode scalar order. Sort policy sources by kind, locator, then revision, with JSON `null` before strings and strings by scalar order. Sort verifier availability by verifier then available, with `false` before `true`. Preserve every other sequence order exactly.

Serialize UTF-8 strings with only quotation mark, reverse solidus, and U+0000 through U+001F escaped as lowercase `\u00xx`; never escape solidus or non-ASCII scalars. Emit exact ASCII JSON literals and delimiters without insignificant whitespace, encode impact as one ASCII digit, SHA-256 the exact bytes, and emit lowercase hexadecimal. A changed mandate, matrix, target, source, verifier, adoption map, conformance PASS, or equality PASS needs a new review and never inherits authority.

## Native creation

The immutable first-line identity is exactly. The role capability profiles are fixed: `supervisor` requires `native-context`, `native-ledger`, and `native-create`; `planner` requires `native-context`; `executor` and `recovery` require `native-context` and `native-task`; `lead-reviewer` and `specialist-reviewer` require `native-context` and `native-review`; `follow-up` requires `native-context`.

```json
{"schema":"octoplan-native-creation-v3","creation_key":{"run_id":"<non-empty string>","subject_kind":"supervisor|task|follow-up","subject_id":"<non-empty string>","attempt_id":"<non-empty string or null>","role":"supervisor|planner|executor|lead-reviewer|specialist-reviewer|recovery|follow-up","route":"<non-empty exact saved route string>","target":{"kind":"<project|projectless>","project_id":"<ID or null>","environment":"<local|worktree or null>","directory_name":"<name or null>","rationale":"<rationale or null>"},"artifact_revision":"<non-empty string or null>","role_packet_digest":"<lowercase SHA-256>"},"role_packet":{"organization":"<non-empty exact organization>","workspace":"<non-empty exact workspace>","work_stream_id":"<non-empty exact work stream ID>","task_id":"<non-empty exact task ID or null>","role":"<supervisor|planner|executor|lead-reviewer|specialist-reviewer|recovery|follow-up>","route":"<non-empty exact saved route string>","target":{"kind":"<project|projectless>","project_id":"<ID or null>","environment":"<local|worktree or null>","directory_name":"<name or null>","rationale":"<rationale or null>"},"model":"<non-empty exact model>","effort":"<non-empty exact effort>","capability_profile":["<sorted required capability>"],"capability_rationale":"<non-empty rationale>","capacity_source":{"kind":"<saved-route|incident-delta>","record_id":"<non-empty>","evidence_digest":"<lowercase SHA-256>"}},"creation_token":"<non-empty unique string>","creator_owner_epoch":"<positive current supervisor epoch at intent>"}
```

The first prompt line is exactly literal `OCTOPLAN_CREATION`, one ASCII space, and the canonical JSON bytes above. The role packet is immutable and its digest is part of `creation_key`; the actor enters the named Octopad context through the Octopad session entrypoint. A packet, capability, capacity source, route, model, effort, or target mismatch pauses activation. The durable creation record stores this immutable identity plus state and wake; `creation_key` excludes token and creator epoch and is the uniqueness key. Supervisor and follow-up subjects use null attempt; task roles use non-null attempt; reviewer roles require non-null artifact revision, while other roles may use null or the exact relevant revision. Before durable `intent`, compare the creation target with the run's inline planning target and stop on a project-identity mismatch. After creation or reconciliation, read actual project identity from native metadata or the registry; prompt text is never proof. A projectless, null-project, or cross-project observation must stop before activation and publish the required pause handoff. At durable `intent`, `creator_owner_epoch` equals the then-current supervisor epoch and is immutable. A takeover monotonically increments the separate current supervisor epoch without changing identity. Activation and every ledger transition require actor epoch == current supervisor epoch. Matching a native candidate compares immutable identity including creator epoch and role packet, then gates transition separately on current epoch. Guard durable `intent` before at most one create call and reconcile every client, direct, empty, crash, zero, one, or multiple response.

Creation states are `intent`, `pending`, `ready`, `activated`, `failed`, and `paused`. Owner epoch fencing rejects late writes; resume reconciles an existing intent without a second create call; every nonterminal pause stores an evidence-based wake predicate. A unique match may become `ready`, then only the current fenced supervisor may activate it.

Creation enters `intent` before the one call. A direct native ID, a client ID, an empty response, or no response all enter reconciliation; none is activation evidence by itself.

Zero exact matches remain `pending` with a wake predicate while bounded reconciliation can still produce the event, then become `paused` with a wake predicate after exhaustion. One exact match becomes `ready`; multiple matches, a mismatched identity, or conflicting owner epoch becomes `paused` and forbids retry.

`activated` is written only after the current owner epoch claims the unique native session. `failed` records a terminal creation failure only when reconciliation proves no usable session and no safe retry.

Repository validation owns the required contract fixtures, including default and autonomous journeys through binding and launch.
