#!/bin/sh
set -eu

root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
skill="$root/plugins/octoplan-codex/skills/octoplan"
runtime="$skill/references/codex-runtime.md"
planning="$skill/references/planning.md"
supervision="$skill/references/codex-supervision.md"
supervision_rel="plugins/octoplan-codex/skills/octoplan/references/codex-supervision.md"
manifest="$root/plugins/octoplan-codex/.codex-plugin/plugin.json"
changelog="$root/CHANGELOG.md"

fail() {
  printf 'FAIL: %s\n' "$1" >&2
  exit 1
}

grep -q '^Version: 6\.1\.0$' "$skill/SKILL.md" || fail 'SKILL.md is not 6.1.0'
grep -q '"version": "6\.1\.0"' "$manifest" || fail 'plugin manifest is not 6.1.0'
grep -q '^### 6\.1\.0 — 2026-08-04$' "$changelog" || fail 'changelog lacks the 6.1.0 entry'
grep -q '^  allow_implicit_invocation: false$' "$skill/agents/openai.yaml" || fail 'implicit invocation remains enabled'
grep -Fq 'Use only when a Codex user explicitly invokes $octoplan' "$skill/SKILL.md" || fail 'explicit invocation boundary is missing'
grep -Fq 'Do not use for general Octopad actions, organization connection, onboarding' "$skill/SKILL.md" || fail 'non-Octoplan exclusions are missing'
[ -f "$supervision" ] || fail 'conditional-supervision runtime is missing'
git -C "$root" ls-files --error-unmatch "$supervision_rel" >/dev/null 2>&1 || fail 'conditional-supervision runtime is not tracked'
[ ! -e "$skill/references/codex-relay.md" ] || fail 'legacy direct-relay runtime remains'

if grep -R -n 'Review: skip\|review is skipped\|review is skipped\|reviewer or directly' \
  "$skill/SKILL.md" "$planning" "$runtime" "$supervision" >/dev/null; then
  fail 'an active review-skip path remains'
fi

if grep -q 'durable completion or required review' "$planning"; then
  fail 'parallel continuation can bypass review'
fi

grep -q 'Every delivery task receives an adversarial check' "$runtime" || fail 'mandatory delivery-task review is missing'
grep -q 'one reviewer by default' "$runtime" || fail 'single-review default is missing'
grep -q 'orthogonal' "$runtime" || fail 'orthogonal second-review gate is missing'
grep -q 'Specialist review route' "$planning" || fail 'task template lacks specialist review route'
grep -q 'Specialist review route' "$supervision" || fail 'supervision lacks specialist review support'
grep -q 'detection difficulty' "$runtime" || fail 'review routing is not detection-based'
grep -q 'immutable artifact revision' "$supervision" || fail 'review PASS is not revision-bound'
grep -q 'fresh recovery executor and the saved calibrated review' "$supervision" || fail 'dead executor recovery has no reviewable path'
grep -q 'why this route;.*mandate' "$planning" || fail 'review routes lack saved rationale and mandate'
grep -q '^Plan review:$' "$planning" || fail 'plan-review routing record is undefined'
grep -q 'Adversarially review the draft' "$planning" || fail 'plan-review routing record is not read back'
grep -q 'Every final binding record carries' "$planning" || fail 'plan-review PASS is not fingerprint-bound'

grep -q 'octoplan-supervision-v4' "$planning" || fail 'supervision contract schema is not planned'
grep -q '^Supervision contract:$' "$planning" || fail 'tracker supervision contract is undefined'
grep -q '^\*\*Fallback: ' "$planning" || fail 'task template lacks bounded fallback routing'
grep -q 'Default recovery:' "$planning" || fail 'contract lacks same-route recovery default'
grep -q 'Default lineage:' "$planning" || fail 'contract lacks immutable lineage default'
grep -q 'at least 2 required observations and exact count' "$planning" || fail 'fallback lacks auditable repeated evidence'
grep -q 'tracker stores only' "$planning" || fail 'supervision contract is copied into trackers'
grep -q '^## Fingerprint$' "$planning" || fail 'pre-consent fingerprint protocol is missing'
grep -Fq '`octoplan-fingerprint-v1`' "$planning" || fail 'fingerprint schema is not named'
pending_hash_count=$(grep -Fc '"plan_hash": "PENDING"' "$planning" || true)
[ "$pending_hash_count" -eq 2 ] || fail 'fingerprint does not define exactly two normalized final-hash fields'
grep -Fq '"supervision_contract": {' "$planning" || fail 'supervision contract is not structured for deterministic hashing'
grep -Fq '"execution_environment": {' "$planning" || fail 'execution environment is not structured for deterministic hashing'
grep -Fq '"task_role_target_overrides": [' "$planning" || fail 'target overrides are absent from the fingerprint'
grep -Fq '"review_pass": "<literal matching Review PASS record>"' "$planning" || fail 'fingerprint omits the binding review PASS'
grep -Fq '"saved_state_equality": true' "$planning" || fail 'fingerprint equality result is not a non-recursive boolean'
grep -Fq '"decision_status": "<exact decision status>"' "$planning" || fail 'fingerprint Decision fields are not structured'
grep -Fq 'never compose them into a synthetic text string' "$planning" || fail 'Decision extraction can produce different bytes'
grep -Fq 'OCTOPLAN_PLAN_MANIFEST_V4_BEGIN' "$planning" || fail 'ledger manifest has no deterministic exclusion boundary'
grep -Fq 'scan every included JSON string value' "$planning" || fail 'fingerprint can still contain a hidden final digest'
grep -Fq '"work_stream_id": "<owning stream ID>"' "$planning" || fail 'fingerprint omits task stream ownership'
grep -Fq '"parent_task_id": "<parent task ID or null>"' "$planning" || fail 'fingerprint omits task hierarchy'
grep -Fq 'all planned agent and human tasks' "$planning" || fail 'fingerprint does not cover agent and human tasks'
grep -Fq 'Normalize line endings in source text to LF only' "$planning" || fail 'fingerprint line-ending normalization is undefined'
grep -Fq 'never the persisted digest or a ledger or tracker copy that carries it' "$planning" || fail 'fingerprint can still hash its own persisted value'
grep -Fq 'split on the first two literal ` · ` separators' "$planning" || fail 'project target extraction is ambiguous'
grep -Fq 'reject a directory name containing the literal separator ` · `' "$planning" || fail 'projectless target delimiter can be ambiguous'
grep -Fq 'sort `task_role_target_overrides` by `task_id`, then `role`' "$planning" || fail 'target override ordering is ambiguous'
grep -Fq 'each U+0000 through U+001F control as lowercase `\u00xx`' "$planning" || fail 'canonical JSON string escaping is undefined'
grep -Fq 'Never escape solidus `/` or non-ASCII scalar values.' "$planning" || fail 'canonical JSON allows alternative string bytes'
grep -q 'conditional supervision policy' "$runtime" || fail 'execution consent omits conditional supervision'
grep -q 'saved fallback' "$runtime" || fail 'execution consent omits saved fallback routes'
grep -Fq 'Execution needs either a later explicit yes on the reviewed plan or an explicit advance authorization given after the user confirmed the scoping brief.' "$runtime" || fail 'legacy and advance consent modes are not both preserved'
grep -Fq 'A bare confirmation, broad autonomy request, prior chat, or permission to plan is not advance authorization.' "$runtime" || fail 'ambiguous consent can escalate to launch authority'
grep -Fq 'no unresolved Question or material delta from the confirmed brief in result, scope, material cost, risk, success, architecture, route bounds, validation mode, or protected actions.' "$runtime" || fail 'advance authority has an incomplete invalidation boundary'
grep -Fq 'A material replan invalidates it.' "$runtime" || fail 'material replans can reuse advance consent'
grep -Fq 'An existing 6.0 plan with `octoplan-supervision-v4` and a later explicit yes on its reviewed final hash remains valid.' "$runtime" || fail '6.0 final-hash consent compatibility is missing'
grep -Fq 'use `tasks(action: "update")` with the coordination-ledger task' "$planning" || fail 'advance consent binding lacks a guarded durable write'
grep -Fq 'append one launch-binding record as a ledger comment' "$planning" || fail 'advance consent binding is not stored in the ledger comments'
grep -Fq 'never put the record in the task description or Plan manifest' "$planning" || fail 'launch binding can contaminate fingerprinted plan text'
grep -Fq 'source reply and time, confirmed-brief digest, exact final plan hash, review PASS, saved-state equality PASS, and no-material-delta assertion' "$planning" || fail 'launch binding omits required evidence'
grep -q 'execution-consent evidence, launch-binding records' "$planning" || fail 'runtime consent evidence changes the plan fingerprint'
grep -q 'Authority is either a later explicit yes on the reviewed plan or an advance authorization plus its guarded launch-binding record' "$supervision" || fail 'supervision cannot verify advance authority'

grep -q 'owner token' "$supervision" || fail 'supervisor owner token is missing'
grep -q 'supervisor epoch' "$supervision" || fail 'supervisor epoch is missing'
grep -q 'intent.*pending.*ready.*activated.*failed' "$supervision" || fail 'creation state machine is incomplete'
grep -q 'wait_threads' "$supervision" || fail 'native monitoring is missing'
grep -q 'Only the current fenced supervisor launches successors' "$skill/SKILL.md" || fail 'successor authority is not exclusive'
grep -q 'never launches a successor' "$supervision" || fail 'lead reviewer can still relay'
grep -q 'current supervision mode.*excluded' "$planning" || fail 'runtime mode would invalidate the plan fingerprint'
grep -q 'Plan manifest' "$supervision" || fail 'multi-stream recovery source is missing'
grep -q 'context, access, environment, and verifier' "$supervision" || fail 'fallback can misdiagnose non-capability failures'
grep -q 'never retry while creation is ambiguous' "$supervision" || fail 'uncertain creation can duplicate sessions'
grep -q 'Every supervisor, executor, reviewer, and recovery creation' "$supervision" || fail 'safe creation does not cover every role'
grep -Fq 'Supervisor title: `supervisor - <plain work stream name>`' "$supervision" || fail 'supervisor title is not human-readable'
grep -Fq 'Executor title: `<plain work stream name> - #<N> <task name>`' "$supervision" || fail 'executor title is not human-readable'
grep -Fq 'Lead reviewer title: `review - <plain work stream name> - #<N> <task name>`' "$supervision" || fail 'lead reviewer title is not human-readable'
grep -Fq 'Specialist reviewer title: `specialist review - <plain work stream name> - #<N> <task name>`' "$supervision" || fail 'specialist reviewer title is not human-readable'
grep -Fq 'Start the first native prompt with the full key and token, never the human-readable title.' "$supervision" || fail 'human titles can replace durable identity'
grep -Fq 'If the required source title cannot be parsed as `#N - <task name>`, pause before creation.' "$supervision" || fail 'thread title can invent a task rank or name'
grep -Fq 'derives this visible title from the ranked parent delivery task' "$supervision" || fail 'repair subtask cannot derive a valid visible title'
grep -Fq 'The first prompt line is exactly `OCTOPLAN_CREATION `' "$supervision" || fail 'creation key serialization is undefined'
grep -Fq '"target":{"directory_name":"<projectless directory name>","environment":"<local|worktree>","kind":"<project|projectless>","project_id":"<project ID>","rationale":"<projectless rationale>"}' "$supervision" || fail 'creation target schema or key order changed'
grep -Fq 'never escape `/` or a non-ASCII scalar' "$supervision" || fail 'creation identity string escaping is ambiguous'
grep -Fq 'removing one terminal ` (octoplanned)` suffix' "$supervision" || fail 'plain stream title normalization is ambiguous'
grep -Fq 'U+007F–U+009F' "$supervision" || fail 'native titles allow C1 control characters'
grep -Fq 'any bidi control U+061C' "$supervision" || fail 'native titles allow unsafe bidi controls'
grep -Fq 'With a returned `clientThreadId`, save `pending`.' "$supervision" || fail 'pending creation has no path to a real thread'
grep -Fq 'Comparing the client ID inside `list_threads` results is allowed' "$supervision" || fail 'pending creation cannot reconcile safely'
grep -Fq 'call `list_threads`, enumerate every current real-thread candidate' "$supervision" || fail 'lost result does not discover native candidates'
grep -Fq 'After every response shape, call `list_threads` and enumerate every current real-thread candidate before `ready`.' "$supervision" || fail 'direct creation can miss a duplicate thread'
grep -q 'read_thread' "$supervision" || fail 'lost-result recovery cannot verify a human-titled thread'
grep -Fqi 'reconcile only one exact match and never retry while creation is ambiguous' "$supervision" || fail 'lost-result recovery can duplicate a session'
grep -q 'reviewer verifies its activated creation record' "$supervision" || fail 'reviewers can work before activation'
grep -q 'Before work, after every wake, and before any write, PASS, or completion' "$supervision" || fail 'reviewers can write after supersession'
grep -q 'supervisor epoch 1' "$supervision" || fail 'fresh runs lack initialized ownership'
grep -q 'Every changed fingerprint, including hygiene' "$supervision" || fail 'plan changes can reuse stale consent'
grep -q 'at least four delivery tasks remain' "$supervision" || fail 'dedicated-parent size gate is missing'
grep -q 'complete saved symmetric parallel group' "$supervision" || fail 'unsaved parallel work can launch'
grep -q 'activate the whole group in one guarded transition' "$supervision" || fail 'parallel children can start before group readiness'
grep -q 'actual model, effort, target, and environment equal the saved inline route and inline supervisor target' "$supervision" || fail 'resume can substitute a supervisor route or target'
grep -q 'dedicated-replacement bound' "$supervision" || fail 'dedicated-parent recovery is unbounded'
grep -q 'spawn_agent.*never user-owned threads' "$runtime" || fail 'plan review creates unapproved user threads'

grep -q 'octoplan-supervision-v4' "$skill/SKILL.md" || fail '6.1 skill does not require the current supervision schema'
grep -q '^Execution environment:$' "$planning" || fail 'plan manifest has no execution-environment contract'
grep -q 'Inline supervisor target:' "$planning" || fail 'inline supervisor target is not saved'
grep -q 'Dedicated supervisor target:' "$planning" || fail 'dedicated supervisor target is not saved'
grep -q 'Default executor target:' "$planning" || fail 'default executor target is not saved'
grep -q 'Task-role target overrides:' "$planning" || fail 'multi-project task-role overrides are not saved'
grep -q 'projectless.*explicit' "$planning" || fail 'projectless target is not an explicit planned choice'
grep -Fq '"project_id": "<project ID or null>"' "$planning" || fail 'fingerprint omits binding project identity'
grep -Fq '"environment": "<local|worktree or null>"' "$planning" || fail 'fingerprint omits binding project environment'
grep -q 'exact saved dedicated supervisor target' "$supervision" || fail 'dedicated bootstrap may infer its project'
grep -q 'exact default executor target or task-role override' "$supervision" || fail 'child creation may infer its project'
grep -q 'saved project ID and environment' "$supervision" || fail 'saved project identity is not reconciled'
grep -q 'target and environment' "$supervision" || fail 'creation records do not bind the native target'
grep -q 'A target mismatch pauses without creating or steering a thread' "$supervision" || fail 'resume can continue in the wrong project'

review_section=$(sed -n '/^## Review routing$/,/^## Execution consent$/p' "$runtime")
printf '%s\n' "$review_section" | grep -q 'gpt-5\.6-luna · effort high' || fail 'Luna high is unreachable for review'
printf '%s\n' "$review_section" | grep -q 'gpt-5\.6-luna · effort xhigh' || fail 'Luna xhigh is unreachable for review'
printf '%s\n' "$review_section" | grep -q 'gpt-5\.6-terra · effort high' || fail 'Terra high is unreachable for review'
printf '%s\n' "$review_section" | grep -q 'gpt-5\.6-terra · effort xhigh' || fail 'Terra xhigh is unreachable for review'

terra_max_count=$(grep -c 'gpt-5\.6-terra · effort max' "$runtime" || true)
[ "$terra_max_count" -ge 2 ] || fail 'Terra max is not reachable for execution and review'

grep -q 'executor or reviewer' "$runtime" || fail 'Sol reviewer lacks a cheaper-route inadequacy gate'
grep -Fq 'combines objectively specified implementation with qualitative product, UX, editorial, semantic, or cross-domain acceptance' "$runtime" || fail 'mixed-task routing has no observable trigger'
grep -Fq 'Route execution through the full rubric using only choices the executor must originate' "$runtime" || fail 'mixed-task execution and review are conflated'
grep -Fq 'judgment assigned only to independent review does not elevate execution' "$runtime" || fail 'mixed-task rationale is not auditable'

grep -Fq 'never print a raw UUID' "$skill/SKILL.md" || fail 'user-facing opaque-identifier rule is missing'
grep -Fq 'codex://threads/<thread-id>' "$skill/SKILL.md" || fail 'Codex session deep-link shape is missing'
grep -Fq 'do not print it in user-facing prose' "$runtime" || fail 'execution consent still exposes the plan hash'
grep -Fq 'PR numbers, migration numbers, task numbers, or `#N` ranks' "$skill/SKILL.md" || fail 'numbering exclusions are not explicit'
grep -Fq 'never print a raw UUID' "$supervision" || fail 'supervision lacks the opaque-identifier rule'
grep -Fq 'required Markdown link destination only' "$skill/SKILL.md" || fail 'skill allows opaque identifiers outside required link destinations'
grep -Fq 'required Markdown link destinations' "$supervision" || fail 'supervision allows opaque identifiers outside required link destinations'
grep -Fq 'only to messages rendered to the user' "$supervision" || fail 'supervision does not scope the presentation rule to user-visible messages'
grep -Fq 'must not be applied to internal supervisor, executor, reviewer, or recovery prompts' "$supervision" || fail 'internal agent communication is not exempted from presentation sanitization'
grep -Fq 'Start every executor prompt with creation token, task ID, run ID, attempt ID' "$supervision" || fail 'executor correlation key is not preserved'
if grep -Fq 'or URLs' "$skill/SKILL.md" || grep -Fq 'URL destinations may retain' "$supervision"; then
  fail 'opaque-identifier exception is broader than required Markdown link destinations'
fi

printf 'PASS: octoplan-codex routing contract\n'
