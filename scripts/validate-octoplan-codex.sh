#!/bin/sh
set -eu

root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
skill="$root/plugins/octoplan-codex/skills/octoplan"
planning="$skill/references/planning.md"
state="$skill/references/state-and-recovery.md"
runtime="$skill/references/codex-runtime.md"
supervision="$skill/references/codex-supervision.md"
tombstone="$skill/references/octoplan-contract-v3.md"
roles="$skill/roles"
manifest="$root/plugins/octoplan-codex/.codex-plugin/plugin.json"
agent_manifest="$skill/agents/openai.yaml"
changelog="$root/CHANGELOG.md"

fail() {
  printf 'FAIL: %s\n' "$1" >&2
  exit 1
}

require_file() {
  [ -f "$1" ] || fail "missing file: $1"
}

require_text() {
  grep -Fq -- "$2" "$1" || fail "missing contract text in $(basename "$1"): $2"
}

for file in "$skill/SKILL.md" "$planning" "$state" "$runtime" "$supervision" "$tombstone" "$manifest" "$agent_manifest"; do
  require_file "$file"
done
for role in planner plan-reviewer supervisor executor reviewer specialist-reviewer recovery follow-up; do
  require_file "$roles/$role.md"
done

grep -q '^Version: 12\.1\.0$' "$skill/SKILL.md" || fail 'Codex SKILL.md is not 12.1.0'
grep -q '"version": "12\.1\.0"' "$manifest" || fail 'Codex plugin is not 12.1.0'
grep -Fq '| [`octoplan-codex`](plugins/octoplan-codex/skills/octoplan/SKILL.md) | Codex | 12.1.0 |' "$root/README.md" || fail 'README Codex version is stale'

expected_refs='codex-runtime.md
codex-supervision.md
octoplan-contract-v3.md
planning.md
state-and-recovery.md'
actual_refs=$(find "$skill/references" -maxdepth 1 -type f -name '*.md' -exec basename '{}' \; | sort)
[ "$actual_refs" = "$expected_refs" ] || fail 'unexpected Codex reference set'
require_text "$tombstone" '# Legacy Octoplan contracts retired'
require_text "$tombstone" 'Do not translate old fingerprints'

active_docs="$skill/SKILL.md $planning $state $runtime $supervision"
for forbidden in 'octoplan-supervision-v6' 'octoplan-fingerprint-v' 'octopad-direct-readback-v1' 'canonical review-subject' 'saved-state equality' 'byte-deterministic' 'plan_hash'; do
  if grep -Fq "$forbidden" $active_docs; then
    fail "retired blocking contract remains active: $forbidden"
  fi
done
if grep -Fq 'references/octoplan-contract-v3.md' "$skill/SKILL.md" "$planning" "$runtime" "$supervision"; then
  fail 'active documents still load the retired contract'
fi

skill_lines=$(wc -l < "$skill/SKILL.md" | tr -d ' ')
planning_lines=$(wc -l < "$planning" | tr -d ' ')
state_lines=$(wc -l < "$state" | tr -d ' ')
runtime_lines=$(wc -l < "$runtime" | tr -d ' ')
supervision_lines=$(wc -l < "$supervision" | tr -d ' ')
[ "$skill_lines" -le 45 ] || fail "SKILL.md exceeds 45 lines: $skill_lines"
[ "$planning_lines" -le 120 ] || fail "planning.md exceeds 120 lines: $planning_lines"
[ "$state_lines" -le 160 ] || fail "state-and-recovery.md exceeds 160 lines: $state_lines"
[ "$runtime_lines" -le 110 ] || fail "codex-runtime.md exceeds 110 lines: $runtime_lines"
[ "$supervision_lines" -le 140 ] || fail "codex-supervision.md exceeds 140 lines: $supervision_lines"
active_lines=$((skill_lines + planning_lines + state_lines + runtime_lines + supervision_lines))
active_words=$(wc -w $active_docs | awk 'END {print $1}')
[ "$active_lines" -le 540 ] || fail "active skill documents exceed 540 lines: $active_lines"
[ "$active_words" -le 6000 ] || fail "active skill documents exceed 6000 words: $active_words"

for toc_file in "$planning" "$state" "$runtime" "$supervision"; do
  require_text "$toc_file" '## Contents'
done
require_text "$skill/SKILL.md" 'Only `octoplan-plan-v2` is supported.'
require_text "$skill/SKILL.md" '`eligible_safe_ready`'
require_text "$skill/SKILL.md" 'Every launched plan gets one dedicated native supervisor'
require_text "$skill/SKILL.md" 'missing `structuredContent`'
require_text "$skill/SKILL.md" 'Record one receipt per item'
require_text "$skill/SKILL.md" 'identity still unresolved after that recovery'
require_text "$planning" 'Ask all currently material questions in one numbered batch'
require_text "$planning" 'never ask actor by actor'
require_text "$planning" 'Never retry blindly'
require_text "$planning" '`bootstrap-dispatch-ambiguous`'
require_text "$planning" 'Octoplan operation key:'
require_text "$planning" 'depends_on_refs'
require_text "$planning" 'streamed tasks use `work_stream_id` and omit `goal_id`'
require_text "$planning" 'page links use `{page_id, rationale}`'
require_text "$planning" 'It never requires exhaustive readback or byte equality.'
require_text "$planning" 'first integrated demonstrable candidate'
require_text "$planning" '`location=embedded`'
require_text "$planning" '`location=human-task`'
require_text "$planning" 'never require all-ready activation'
require_text "$planning" 'backfill'
require_text "$planning" 'authoritative telemetry is observable'
require_text "$planning" 'Follow active `AGENTS.md` and repository workflow.'
require_text "$planning" 'persist `draft` with `proposed_revision`'
require_text "$planning" 'Never launch before `approved`.'
require_text "$state" 'Use `expected_updated_at` on every state-changing update.'
require_text "$state" 'one UUID `idempotency_key` per logical event'
require_text "$state" 'The plan ID plus approved integer revision is the execution identity.'
require_text "$state" '"schema": "octoplan-plan-v2"'
require_text "$state" '"actions": ["create", "message", "archive"]'
require_text "$state" '`active -> awaiting-review -> correction-needed | handoff-pending -> terminal-reconciled -> archived`'
require_text "$state" '`archive_receipt`'
require_text "$state" '"proposed_revision": 1'
require_text "$state" '"approved_revision": null'
require_text "$state" '"execution_authority": null'
require_text "$state" '"execution_authority"'
require_text "$state" '`review-before-delivery` pairs only with exact-revision `revision-approval`'
require_text "$state" 'OCTOPLAN_WRITE_INTENT <operation-key>'
require_text "$state" '`structuredContent` is useful when present but never mandatory.'
require_text "$state" 'Never replay the whole batch because one item is unclear.'
require_text "$state" 'Before every create, message, or archive, persist one intent'
require_text "$state" 'never blind replay'
require_text "$state" '"native_action_receipts": []'
require_text "$state" 'Targeted recovery'
require_text "$runtime" 'One exact user source may grant enumerated create/message/archive actions'
require_text "$runtime" 'dedicated compact, delta-first supervisor uses Terra `high` by default'
require_text "$runtime" 'Treat `clientThreadId` as pending setup'
require_text "$runtime" 'incomplete native metadata is an evidence defect'
require_text "$runtime" 'persisted target/receipt'
require_text "$runtime" 'metadata-only anomaly does not block'
require_text "$runtime" 'Product, code, security, privacy, data, migration, and materially public changes require `independent`.'
require_text "$runtime" 'one additional fresh reviewer only for a second material and orthogonal failure domain'
require_text "$supervision" "Use Octopad's graph/statuses directly"
require_text "$supervision" '`eligible_safe_ready`'
require_text "$supervision" 'Never require all-ready activation'
require_text "$supervision" 'After two `REVISE` with the same key'
require_text "$supervision" 'global integrated-outcome evidence'
require_text "$supervision" 'Never retry create to improve a response'
require_text "$supervision" 'Silence, timeout, missing checks'
require_text "$supervision" 'Contact the user only for a material choice'
require_text "$supervision" 'at most two distinct safe, reversible remedies'
require_text "$supervision" 'Reuse an existing no-mutation actor'
require_text "$supervision" 'seek new authority only for changed scope, target, risk, or a new protected action'
require_text "$supervision" 'Secrets, access grants, spend, destructive effects, required human review, merge, migration application, deployment, publication, and acceptance'
require_text "$supervision" '`État`'
require_text "$supervision" '`Prochaine étape`'
require_text "$supervision" 'owning E task'
require_text "$supervision" 'tokens, tool calls, compactions, and retries'
require_text "$manifest" 'plan-scoped Codex create/message/archive grant'
require_text "$agent_manifest" 'plan-scoped Codex create/message/archive grant'

for role in planner supervisor executor reviewer specialist-reviewer recovery follow-up; do
  require_text "$roles/$role.md" 'role packet'
  require_text "$roles/$role.md" 'Octopad context'
done
require_text "$roles/plan-reviewer.md" 'fresh read-only pre-run subagent'
require_text "$roles/plan-reviewer.md" '`PASS`, `REVISE`, `INFEASIBLE`, or `HUMAN_DECISION`'

[ "$(grep -Fc '| Work profile |' "$runtime")" -eq 1 ] || fail 'capacity ladder is duplicated or missing'
[ "$(grep -Ec '^\| .*`gpt-5\.6-' "$runtime")" -eq 5 ] || fail 'capacity ladder does not have five routes'

changes_file=$(mktemp "${TMPDIR:-/tmp}/octoplan-changes.XXXXXX")
trap 'rm -f "$changes_file"' EXIT HUP INT TERM
{
  git -C "$root" diff --name-only origin/main
  git -C "$root" diff --cached --name-only
  git -C "$root" ls-files --others --exclude-standard
} | sort -u > "$changes_file"

private_material_pattern="/""Users/|[[:alnum:]._%+-]+@[[:alnum:].-]+\.[[:alpha:]]{2,}|BEGIN (RSA |OPENSSH |EC )?PRIVATE KEY"
while IFS= read -r changed; do
  case "$changed" in
    .claude-plugin|.claude-plugin/*|plugins/octoplan-claude|plugins/octoplan-claude/*|docs/clients/claude.md|docs/clients/claude-code.md)
      fail "protected Claude surface changed: $changed"
      ;;
  esac
  if [ -f "$root/$changed" ] && grep -E "$private_material_pattern" "$root/$changed" >/dev/null 2>&1; then
    fail "private or identifying material appears in public file: $changed"
  fi
done < "$changes_file"

origin_claude=$(git -C "$root" show origin/main:CHANGELOG.md | sed -n '/^## octoplan-claude$/,$p')
current_claude=$(sed -n '/^## octoplan-claude$/,$p' "$changelog")
[ "$origin_claude" = "$current_claude" ] || fail 'Claude changelog section changed'

node <<'NODE'
const assert = require('assert');

const materialFields = new Set(['outcome', 'candidate', 'scope', 'success', 'taskMeaning', 'dependencies', 'parallelism', 'budgets', 'protectedGates', 'owner', 'route', 'authority', 'acceptance']);
const pauseReasons = new Set(['wrong-target', 'unreconcilable-duplicate', 'bootstrap-dispatch-ambiguous', 'creation-dispatch-ambiguous', 'missing-authority', 'proven-missing-write', 'revision-conflict', 'protected-gate', 'human-decision']);
const protectedKinds = new Set(['secret', 'access-grant', 'external-spend', 'destructive-effect', 'human-review', 'merge', 'migration-application', 'deployment', 'publication', 'acceptance']);
const runStatuses = new Set(['draft', 'awaiting-approval', 'approved', 'active', 'replanning', 'waiting-human', 'paused', 'completed', 'superseded']);
const actorRoles = new Set(['supervisor', 'planner', 'executor', 'reviewer', 'specialist-reviewer', 'recovery', 'follow-up']);
const actorStates = new Set(['active', 'awaiting-review', 'correction-needed', 'handoff-pending', 'terminal-reconciled', 'archived']);

function validatePlan(plan) {
  assert.strictEqual(plan.schema, 'octoplan-plan-v2');
  assert(typeof plan.plan_id === 'string' && plan.plan_id.length > 0);
  assert(runStatuses.has(plan.status));
  assert(plan.proposed_revision === null || (Number.isInteger(plan.proposed_revision) && plan.proposed_revision > 0));
  assert(plan.approved_revision === null || (Number.isInteger(plan.approved_revision) && plan.approved_revision > 0));
  for (const key of ['organization_id', 'workspace_id', 'work_stream_id', 'coordination_task_id']) assert(typeof plan[key] === 'string' && plan[key].length > 0);
  assert(plan.outcome && /^E[0-9]+$/.test(plan.outcome.candidate_ref));
  const preApproval = ['draft', 'awaiting-approval'].includes(plan.status);
  if (preApproval) {
    assert(Number.isInteger(plan.proposed_revision) && plan.proposed_revision > 0);
    assert.strictEqual(plan.approved_revision, null);
    assert.strictEqual(plan.execution_authority, null);
    assert.strictEqual(plan.supervisor, null);
    if (plan.status === 'awaiting-approval') assert(plan.review && plan.review.revision === plan.proposed_revision && plan.review.verdict === 'PASS');
    if (plan.review) assert(plan.review.revision === plan.proposed_revision);
  } else {
    assert(Number.isInteger(plan.approved_revision) && plan.approved_revision > 0);
    assert(plan.review && plan.review.revision === plan.approved_revision && plan.review.verdict === 'PASS');
    assert(plan.execution_authority && typeof plan.execution_authority.source_ref === 'string' && plan.execution_authority.source_ref.length > 0);
    assert(['revision-approval', 'bounded-outcome'].includes(plan.execution_authority.kind));
    if (plan.delivery_mode === 'review-before-delivery') {
      assert.strictEqual(plan.execution_authority.kind, 'revision-approval');
      assert.strictEqual(plan.execution_authority.approved_revision, plan.approved_revision);
      assert.strictEqual(plan.execution_authority.outcome_boundary_ref, null);
    } else {
      assert.strictEqual(plan.delivery_mode, 'autonomous-delivery');
      assert.strictEqual(plan.execution_authority.kind, 'bounded-outcome');
      assert(plan.execution_authority.approved_revision === null && typeof plan.execution_authority.outcome_boundary_ref === 'string' && plan.execution_authority.outcome_boundary_ref.length > 0);
    }
    assert(plan.supervisor && Number.isInteger(plan.supervisor.epoch) && plan.supervisor.epoch > 0 && plan.supervisor.dedicated === true);
    assert(typeof plan.supervisor.title === 'string' && /^Supervisor - .+ - .+/.test(plan.supervisor.title) && plan.supervisor.title.length <= 64);
  }
  if (plan.review) {
    assert(typeof plan.review.reviewer_ref === 'string' && plan.review.reviewer_ref.length > 0);
    assert(typeof plan.review.evidence_ref === 'string' && plan.review.evidence_ref.length > 0);
  }
  assert(plan.creation_grant && typeof plan.creation_grant.source_ref === 'string' && plan.creation_grant.source_ref.length > 0);
  assert.strictEqual(plan.creation_grant.plan_id, plan.plan_id);
  assert(Array.isArray(plan.creation_grant.actions) && plan.creation_grant.actions.length > 0);
  assert(plan.creation_grant.actions.every(action => ['create', 'message', 'archive'].includes(action)));
  assert.strictEqual(new Set(plan.creation_grant.actions).size, plan.creation_grant.actions.length);
  assert(Array.isArray(plan.creation_grant.adopted_session_refs));
  assert(Array.isArray(plan.creation_grant.roles) && plan.creation_grant.roles.length > 0);
  assert(plan.creation_grant.roles.every(role => actorRoles.has(role)));
  assert.strictEqual(new Set(plan.creation_grant.roles).size, plan.creation_grant.roles.length);
  assert(Array.isArray(plan.creation_grant.environments) && plan.creation_grant.environments.length > 0);
  if (plan.creation_grant.project_id === null) {
    assert(typeof plan.creation_grant.directory_name === 'string' && plan.creation_grant.directory_name.length > 0);
    assert.deepStrictEqual(plan.creation_grant.environments, [null]);
  } else {
    assert(typeof plan.creation_grant.project_id === 'string' && plan.creation_grant.project_id.length > 0);
    assert.strictEqual(plan.creation_grant.directory_name, null);
    assert(plan.creation_grant.environments.every(environment => environment === 'local' || environment === 'worktree'));
    assert.strictEqual(new Set(plan.creation_grant.environments).size, plan.creation_grant.environments.length);
  }
  const refs = new Set(Object.keys(plan.task_ids));
  assert(refs.size > 0);
  assert(Object.values(plan.task_ids).every(id => typeof id === 'string' && id.length > 0));
  assert.strictEqual(new Set(Object.values(plan.task_ids)).size, refs.size);
  for (const edge of plan.desired_dependencies) {
    assert(refs.has(edge.task_ref) && refs.has(edge.depends_on_ref));
    assert(typeof edge.rationale === 'string' && edge.rationale.length > 0);
  }
  const gateKeys = new Set();
  assert(refs.has(plan.outcome.candidate_ref));
  assert(plan.budgets && plan.counters);
  for (const key of ['max_active_child_actors', 'max_wip', 'max_correction_loops', 'max_review_actors', 'max_review_checks', 'batch_size']) assert(Number.isInteger(plan.budgets[key]) && plan.budgets[key] > 0);
  for (const forbidden of ['tokens', 'tool_calls', 'compactions', 'time', 'cost']) assert(!(forbidden in plan.budgets));
  for (const value of Object.values(plan.counters)) {
    if (typeof value === 'object') for (const nested of Object.values(value)) assert(Number.isInteger(nested) && nested >= 0);
    else assert(Number.isInteger(value) && value >= 0);
  }
  assert(plan.counters.active_child_actors <= plan.budgets.max_active_child_actors && plan.counters.wip <= plan.budgets.max_wip);
  assert(plan.counters.review_actors <= plan.budgets.max_review_actors && plan.counters.review_checks <= plan.budgets.max_review_checks);
  if (plan.telemetry_limits) {
    assert.strictEqual(plan.telemetry_observable, true);
    for (const value of Object.values(plan.telemetry_limits)) assert(Number.isInteger(value) && value > 0);
  }
  const humanTaskRefs = new Set();
  for (const gate of plan.protected_gates) {
    assert(protectedKinds.has(gate.kind) && refs.has(gate.delivery_task_ref) && /^E[0-9]+$/.test(gate.delivery_task_ref));
    assert(typeof gate.gate_key === 'string' && gate.gate_key.length > 0 && !gateKeys.has(gate.gate_key));
    assert(['pending', 'satisfied', 'rejected'].includes(gate.state));
    for (const key of ['owner', 'target_effect', 'resume_predicate']) assert(typeof gate[key] === 'string' && gate[key].length > 0);
    assert(gate.evidence_ref === null || (typeof gate.evidence_ref === 'string' && gate.evidence_ref.length > 0));
    if (['human-review', 'merge'].includes(gate.kind)) {
      assert.strictEqual(gate.location, 'embedded');
      assert.strictEqual(gate.human_task_ref, null);
    } else if (gate.location === 'human-task') {
      assert(refs.has(gate.human_task_ref) && /^H[0-9]+$/.test(gate.human_task_ref) && !humanTaskRefs.has(gate.human_task_ref));
      humanTaskRefs.add(gate.human_task_ref);
    } else assert.strictEqual(gate.location, 'embedded');
    gateKeys.add(gate.gate_key);
  }
  for (const [actorRef, actor] of Object.entries(plan.actors)) {
    assert.strictEqual(actor.actor_ref, actorRef);
    assert(actorStates.has(actor.state));
    assert(actorRoles.has(actor.role) && /^E[0-9]+$|^PLAN$/.test(actor.task_ref));
    if (actor.project_id === null) {
      assert(typeof actor.directory_name === 'string' && actor.directory_name.length > 0 && actor.environment === null);
    } else {
      assert(typeof actor.project_id === 'string' && actor.project_id.length > 0 && ['local', 'worktree'].includes(actor.environment));
    }
    assert(actor.provenance && typeof actor.provenance.creation_key === 'string' && typeof actor.provenance.grant_source_ref === 'string');
    assert.strictEqual(actor.provenance.grant_source_ref, plan.creation_grant.source_ref);
    assert(['create', 'message', 'archive'].includes(actor.provenance.action));
    assert(actor.provenance.adopted_session_ref === null || plan.creation_grant.adopted_session_refs.includes(actor.provenance.adopted_session_ref));
    assert(grantCovers(plan.creation_grant, {...actor, adopted_session_ref: actor.provenance.adopted_session_ref}, actor.provenance.action, plan.plan_id));
    for (const flag of ['pending_correction', 'pending_recheck', 'waiting_human', 'handoff_pending']) assert(typeof actor[flag] === 'boolean');
    if (actor.previous_state === null) assert.strictEqual(actor.state, 'active');
    else {
      assert(actorStates.has(actor.previous_state) && validActorTransition(actor.previous_state, actor.state));
      assert(typeof actor.transition_evidence_ref === 'string' && actor.transition_evidence_ref.length > 0);
    }
    if (['awaiting-review', 'terminal-reconciled', 'archived'].includes(actor.state)) assert(typeof actor.report_ref === 'string' && actor.report_ref.length > 0);
    if (actor.state === 'awaiting-review') assert(actor.pending_recheck && !actor.pending_correction);
    if (actor.state === 'correction-needed') assert(actor.pending_correction && typeof actor.finding_ref === 'string' && actor.finding_ref.length > 0);
    if (actor.state === 'handoff-pending') assert(actor.handoff_pending && typeof actor.report_ref === 'string' && actor.report_ref.length > 0);
    if (['terminal-reconciled', 'archived'].includes(actor.state)) assert(actor.transfer_receipt && actor.reconciliation_receipt);
    if (actor.state === 'archived') {
      assert(actor.terminal_reason && ['PASS', 'abandoned', 'superseded'].includes(actor.terminal_reason));
      assert(actor.transfer_receipt && actor.archive_receipt);
      assert(!actor.pending_correction && !actor.pending_recheck && !actor.waiting_human && !actor.handoff_pending);
      assert(plan.creation_grant.actions.includes('archive'));
    }
  }
  assert(plan.resume && Array.isArray(plan.resume.pending_operation_keys));
  assert(Array.isArray(plan.native_action_intents));
  for (const intent of plan.native_action_intents) {
    for (const key of ['action_key', 'action', 'target_ref', 'effect_ref', 'grant_source_ref', 'role']) assert(typeof intent[key] === 'string' && intent[key].length > 0);
    if (intent.project_id === null) {
      assert(typeof intent.directory_name === 'string' && intent.directory_name.length > 0);
      assert.strictEqual(intent.environment, null);
    } else {
      assert(typeof intent.project_id === 'string' && intent.project_id.length > 0);
      assert.strictEqual(intent.directory_name, null);
      assert(['local', 'worktree'].includes(intent.environment));
    }
    assert(['create', 'message', 'archive'].includes(intent.action) && plan.creation_grant.actions.includes(intent.action));
    assert.strictEqual(intent.plan_id, plan.plan_id);
    assert.strictEqual(intent.grant_source_ref, plan.creation_grant.source_ref);
    assert(grantCovers(plan.creation_grant, {...intent, adopted_session_ref: intent.adopted_session_ref ?? null}, intent.action, plan.plan_id));
    assert(Number.isInteger(intent.epoch) && intent.epoch > 0);
    assert(['pending', 'confirmed', 'ambiguous', 'failed'].includes(intent.result));
  }
  assert(Array.isArray(plan.native_action_receipts));
  for (const receipt of plan.native_action_receipts) {
    for (const key of ['action_key', 'target_ref', 'observed_effect_ref', 'grant_source_ref', 'evidence_ref']) assert(typeof receipt[key] === 'string' && receipt[key].length > 0);
    assert(['create', 'message', 'archive'].includes(receipt.action));
    assert(Number.isInteger(receipt.epoch) && receipt.epoch > 0);
    assert(['confirmed', 'absent', 'conflict'].includes(receipt.result));
  }
  if (plan.status === 'completed') {
    assert(typeof plan.outcome.global_evidence_ref === 'string' && plan.outcome.global_evidence_ref.length > 0);
    assert.strictEqual(plan.outcome.global_evidence_revision, plan.approved_revision);
    assert(plan.protected_gates.every(gate => gate.state === 'satisfied' && typeof gate.evidence_ref === 'string' && gate.evidence_ref.length > 0));
    assert.strictEqual(plan.resume.pending_operation_keys.length, 0);
    assert(Object.values(plan.actors).every(actor => ['terminal-reconciled', 'archived'].includes(actor.state)));
  }
  return true;
}

const plan = {
  schema: 'octoplan-plan-v2', plan_id: 'plan-a', proposed_revision: null, approved_revision: 1, status: 'approved',
  organization_id: 'org-a', workspace_id: 'workspace-a', work_stream_id: 'stream-a', coordination_task_id: 'task-control',
  outcome: {candidate_ref: 'E01', global_evidence_ref: null, global_evidence_revision: null},
  delivery_mode: 'autonomous-delivery', task_ids: {E01: 'task-a', E02: 'task-b', H01: 'task-c'},
  execution_authority: {source_ref: 'message-execution', kind: 'bounded-outcome', approved_revision: null, outcome_boundary_ref: 'message-outcome'},
  desired_dependencies: [{task_ref: 'E02', depends_on_ref: 'E01', rationale: 'needs artifact'}],
  review: {revision: 1, verdict: 'PASS', reviewer_ref: 'reviewer-a', evidence_ref: 'evidence-a'},
  supervisor: {owner_thread_id: null, epoch: 1, dedicated: true, title: 'Supervisor - plan-a - delivery'},
  creation_grant: {source_ref: 'message-a', plan_id: 'plan-a', project_id: 'project-a', directory_name: null, environments: ['local', 'worktree'], roles: ['executor', 'reviewer', 'supervisor'], actions: ['create', 'message', 'archive'], adopted_session_refs: []},
  budgets: {max_active_child_actors: 2, max_wip: 2, max_correction_loops: 2, max_review_actors: 2, max_review_checks: 8, batch_size: 2},
  counters: {active_child_actors: 0, wip: 0, correction_loops: {}, review_actors: 0, review_checks: 0},
  protected_gates: [
    {gate_key: 'review-a', kind: 'human-review', location: 'embedded', delivery_task_ref: 'E02', human_task_ref: null, owner: 'maintainer', target_effect: 'approve exact head', evidence_ref: null, state: 'pending', resume_predicate: 'review evidence matches head'},
    {gate_key: 'merge-a', kind: 'merge', location: 'embedded', delivery_task_ref: 'E02', human_task_ref: null, owner: 'maintainer', target_effect: 'merge exact head', evidence_ref: null, state: 'pending', resume_predicate: 'merge receipt matches head'},
    {gate_key: 'deploy-a', kind: 'deployment', location: 'human-task', delivery_task_ref: 'E02', human_task_ref: 'H01', owner: 'operator', target_effect: 'deploy release', evidence_ref: null, state: 'pending', resume_predicate: 'deployment receipt exists'}
  ],
  actors: {}, native_action_intents: [], native_action_receipts: [],
  resume: {last_event_id: null, pending_operation_keys: []}
};
assert(validatePlan(plan));
assert(validatePlan(JSON.parse(JSON.stringify(plan))));
const draftPlan = {...plan, status: 'draft', proposed_revision: 1, approved_revision: null, review: null, execution_authority: null, supervisor: null};
const awaitingPlan = {...draftPlan, status: 'awaiting-approval', review: {revision: 1, verdict: 'PASS', reviewer_ref: 'reviewer-a', evidence_ref: 'evidence-a'}};
const approvalAuthority = {source_ref: 'message-review', kind: 'revision-approval', approved_revision: 1, outcome_boundary_ref: null};
assert(validatePlan(draftPlan));
assert(validatePlan(awaitingPlan));
assert.throws(() => validatePlan({...awaitingPlan, review: null}));
assert.throws(() => validatePlan({...draftPlan, execution_authority: plan.execution_authority}));
assert.throws(() => validatePlan({...plan, status: 'approved', approved_revision: null, proposed_revision: 1}));
function approveCandidate(candidate, expectedUpdatedAt, actualUpdatedAt, authority, supervisor) {
  assert.strictEqual(candidate.status, 'awaiting-approval');
  assert.strictEqual(expectedUpdatedAt, actualUpdatedAt);
  assert(candidate.review && candidate.review.revision === candidate.proposed_revision && candidate.review.verdict === 'PASS');
  assert(authority && authority.source_ref);
  return {...candidate, status: 'approved', approved_revision: candidate.proposed_revision, proposed_revision: null, execution_authority: authority, supervisor};
}
const awaitingReviewPlan = {...awaitingPlan, delivery_mode: 'review-before-delivery'};
assert(validatePlan(approveCandidate(awaitingReviewPlan, 'v1', 'v1', approvalAuthority, plan.supervisor)));
assert.throws(() => approveCandidate(awaitingReviewPlan, 'v1', 'v2', approvalAuthority, plan.supervisor));
assert(validatePlan({...plan, creation_grant: {...plan.creation_grant, project_id: null, directory_name: 'projectless-output', environments: [null]}}));
assert.throws(() => validatePlan({...plan, approved_revision: 2}));
const reviewBeforePlan = {...plan, delivery_mode: 'review-before-delivery', execution_authority: approvalAuthority};
assert(validatePlan(reviewBeforePlan));
assert.throws(() => validatePlan({...plan, delivery_mode: 'review-before-delivery'}));
assert.throws(() => validatePlan({...reviewBeforePlan, delivery_mode: 'autonomous-delivery'}));
assert.throws(() => validatePlan({...plan, status: 'revoked'}));
assert.throws(() => validatePlan({...plan, task_ids: {E01: 'task-a', E02: 'task-a', H01: 'task-c'}}));
assert.throws(() => validatePlan({...plan, task_ids: {E01: '', E02: 'task-b', H01: 'task-c'}}));
assert.throws(() => validatePlan({...plan, protected_gates: [...plan.protected_gates, {...plan.protected_gates[0], gate_key: 'merge-a'}]}));
assert.throws(() => validatePlan({...plan, protected_gates: [{...plan.protected_gates[1], location: 'human-task', human_task_ref: 'H01'}]}));
assert.throws(() => validatePlan({...plan, protected_gates: [{...plan.protected_gates[2], human_task_ref: 'E01'}]}));
assert.throws(() => validatePlan({...plan, protected_gates: [{gate_key: 'merge-a', kind: 'merge'}]}));
assert.throws(() => validatePlan({...plan, creation_grant: {roles: ['executor']}}));
assert.throws(() => validatePlan({...plan, creation_grant: {...plan.creation_grant, project_id: null, directory_name: null, environments: [null]}}));
assert.throws(() => validatePlan({...plan, creation_grant: {...plan.creation_grant, environments: [null]}}));
assert.throws(() => validatePlan({...plan, creation_grant: {...plan.creation_grant, actions: ['create', 'delete']}}));
assert.throws(() => validatePlan({...plan, supervisor: {...plan.supervisor, dedicated: false}}));
assert.throws(() => validatePlan({...plan, supervisor: {...plan.supervisor, title: 'Supervisor - ' + 'x'.repeat(70)}}));
assert.throws(() => validatePlan({...plan, budgets: {...plan.budgets, tokens: 1000}}));
assert.throws(() => validatePlan({...plan, counters: {...plan.counters, wip: -1}}));
assert.throws(() => validatePlan({...plan, counters: {...plan.counters, review_checks: 9}}));
assert.throws(() => validatePlan({...plan, telemetry_limits: {tokens: 1000}, telemetry_observable: false}));
assert(validatePlan({...plan, telemetry_limits: {tool_calls: 20}, telemetry_observable: true}));
assert.throws(() => validatePlan({...plan, review: {revision: 1, verdict: 'PASS'}}));
assert.throws(() => validatePlan({...plan, resume: {last_event_id: null}}));
const actorBase = {actor_ref: 'executorA', role: 'executor', task_ref: 'E01', project_id: 'project-a', environment: 'local', provenance: {creation_key: 'create-a', grant_source_ref: 'message-a', action: 'create', adopted_session_ref: null}, pending_correction: false, pending_recheck: false, waiting_human: false, handoff_pending: false};
const awaitingActor = {...actorBase, state: 'awaiting-review', previous_state: 'active', transition_evidence_ref: 'transition-review', report_ref: 'report-review', pending_recheck: true};
const archivedActor = {...actorBase, state: 'archived', previous_state: 'terminal-reconciled', transition_evidence_ref: 'transition-a', report_ref: 'report-a', terminal_reason: 'PASS', transfer_receipt: 'transfer-a', reconciliation_receipt: 'reconcile-a', archive_receipt: 'archive-a'};
assert(validatePlan({...plan, actors: {executorA: awaitingActor}}));
assert.throws(() => validatePlan({...plan, actors: {executorA: {...awaitingActor, pending_recheck: false}}}));
assert(validatePlan({...plan, actors: {executorA: archivedActor}}));
assert.throws(() => validatePlan({...plan, actors: {executorA: {...archivedActor, transfer_receipt: null}}}));
assert.throws(() => validatePlan({...plan, actors: {executorA: {...archivedActor, waiting_human: true}}}));
assert.throws(() => validatePlan({...plan, creation_grant: {...plan.creation_grant, actions: ['create', 'message']}, actors: {executorA: archivedActor}}));
assert.throws(() => validatePlan({...plan, actors: {executorA: {...archivedActor, role: 'unknown'}}}));
assert.throws(() => validatePlan({...plan, actors: {executorA: {...archivedActor, previous_state: 'active'}}}));
assert.throws(() => validatePlan({...plan, actors: {executorA: {...archivedActor, transition_evidence_ref: null}}}));

const satisfiedGates = plan.protected_gates.map(gate => ({...gate, state: 'satisfied', evidence_ref: `${gate.gate_key}-evidence`}));
const completedPlan = {...plan, status: 'completed', outcome: {...plan.outcome, global_evidence_ref: 'integration-proof-a', global_evidence_revision: 1}, protected_gates: satisfiedGates, actors: {executorA: archivedActor}};
assert(validatePlan(completedPlan));
assert.throws(() => validatePlan({...completedPlan, outcome: {...completedPlan.outcome, global_evidence_ref: null}}));
assert.throws(() => validatePlan({...completedPlan, outcome: {...completedPlan.outcome, global_evidence_revision: 2}}));
assert.throws(() => validatePlan({...completedPlan, protected_gates: plan.protected_gates}));
assert.throws(() => validatePlan({...completedPlan, resume: {last_event_id: null, pending_operation_keys: ['pending-a']}}));
assert.throws(() => validatePlan({...completedPlan, actors: {executorA: {...actorBase, state: 'active', previous_state: null}}}));

function validActorTransition(from, to) {
  const allowed = {
    active: ['awaiting-review', 'handoff-pending'],
    'awaiting-review': ['correction-needed', 'handoff-pending', 'terminal-reconciled'],
    'correction-needed': ['active', 'handoff-pending'],
    'handoff-pending': ['active', 'terminal-reconciled'],
    'terminal-reconciled': ['archived'],
    archived: []
  };
  return allowed[from]?.includes(to) === true;
}
assert(validActorTransition('active', 'awaiting-review'));
assert(validActorTransition('awaiting-review', 'correction-needed'));
assert(validActorTransition('terminal-reconciled', 'archived'));
assert(!validActorTransition('active', 'archived'));
assert(!validActorTransition('handoff-pending', 'archived'));

function changeNeedsRevision(changes) {
  return changes.some(change => materialFields.has(change));
}
assert(changeNeedsRevision(['dependencies']));
assert(changeNeedsRevision(['authority']));
assert(!changeNeedsRevision(['displayName', 'descriptionFormatting', 'responseShape', 'links', 'status', 'receipt']));

function reconcileWrites(expected, responseItems, observations) {
  return expected.map(operation => {
    const response = responseItems.find(item => item.operation_key === operation.operation_key && item.id && item.success === true);
    if (response) return {operation_key: operation.operation_key, action: 'CONFIRMED', id: response.id, evidence: 'write-response'};
    const observed = observations.filter(item => item.operation_key === operation.operation_key);
    if (observed.length === 1 && observed[0].id) return {operation_key: operation.operation_key, action: 'CONFIRMED', id: observed[0].id, evidence: 'targeted-read'};
    if (observed.length === 0 && operation.absence_proven === true) return {operation_key: operation.operation_key, action: 'RETRY_ITEM'};
    return {operation_key: operation.operation_key, action: 'PENDING'};
  });
}
const writes = [
  {operation_key: 'plan-a:r1:task:E01'},
  {operation_key: 'plan-a:r1:task:E02'},
  {operation_key: 'plan-a:r1:task:E03', absence_proven: true}
];
assert.deepStrictEqual(reconcileWrites(writes, [{operation_key: writes[0].operation_key, id: 'task-a', success: true}], [{operation_key: writes[1].operation_key, id: 'task-b'}]).map(x => x.action), ['CONFIRMED', 'CONFIRMED', 'RETRY_ITEM']);
assert.deepStrictEqual(reconcileWrites([{operation_key: 'unclear'}], [], []).map(x => x.action), ['PENDING']);
assert.deepStrictEqual(reconcileWrites([{operation_key: 'no-structured-content'}], [{operation_key: 'no-structured-content', id: 'task-x', success: true}], []).map(x => x.action), ['CONFIRMED']);

function projectIdentityDecision(evidence, recoveryAttempts = 0) {
  if (evidence.directProject === 'expected') return 'CONFIRMED_DIRECT';
  if (evidence.directProject && evidence.directProject !== 'expected') return 'STOP_WRONG_TARGET';
  if (evidence.remoteKnown === false || evidence.actualMismatch === true || evidence.candidates > 1 || evidence.mutated === true) return 'STOP_UNSAFE_OR_CONFLICTING';
  const alternate = ['targetedReceipt', 'returnedTask', 'creationKey', 'rolePacket', 'savedProjectMapping', 'cwdAndToplevel', 'normalizedRemote', 'branchAndHeadRecorded', 'noMutation']
    .every(key => evidence[key] === true);
  if (alternate && evidence.candidates === 1) return 'CONFIRMED_ALTERNATE';
  return recoveryAttempts >= 2 ? 'PAUSE_IDENTITY_UNRESOLVED' : 'RECOVER_IDENTITY';
}
const alternateIdentity = {directProject: null, candidates: 1, targetedReceipt: true, returnedTask: true, creationKey: true, rolePacket: true, savedProjectMapping: true, cwdAndToplevel: true, normalizedRemote: true, branchAndHeadRecorded: true, noMutation: true};
assert.strictEqual(projectIdentityDecision({directProject: 'expected'}), 'CONFIRMED_DIRECT');
assert.strictEqual(projectIdentityDecision(alternateIdentity), 'CONFIRMED_ALTERNATE');
assert.strictEqual(projectIdentityDecision({...alternateIdentity, normalizedRemote: false}), 'RECOVER_IDENTITY');
assert.strictEqual(projectIdentityDecision({...alternateIdentity, normalizedRemote: false}, 2), 'PAUSE_IDENTITY_UNRESOLVED');
assert.strictEqual(projectIdentityDecision({...alternateIdentity, directProject: 'wrong'}), 'STOP_WRONG_TARGET');
assert.strictEqual(projectIdentityDecision({...alternateIdentity, candidates: 2}), 'STOP_UNSAFE_OR_CONFLICTING');
assert.strictEqual(projectIdentityDecision({...alternateIdentity, mutated: true}), 'STOP_UNSAFE_OR_CONFLICTING');

function creationDecision(intentExists, observed, boundedReconciliationComplete = false) {
  const exact = observed.filter(item => item === 'exact' || item === 'alternate');
  if (intentExists && observed.length === 1 && exact.length === 1) return 'ADOPT_EXISTING';
  if (observed.length > 0) return 'PAUSE_UNPROVEN_OR_CONFLICTING';
  if (!intentExists) return 'WRITE_INTENT_AND_CREATE_ONCE';
  return boundedReconciliationComplete ? 'PAUSE_CREATION_DISPATCH_AMBIGUOUS' : 'PENDING';
}
assert.strictEqual(creationDecision(false, []), 'WRITE_INTENT_AND_CREATE_ONCE');
assert.strictEqual(creationDecision(false, ['exact']), 'PAUSE_UNPROVEN_OR_CONFLICTING');
assert.strictEqual(creationDecision(true, ['alternate']), 'ADOPT_EXISTING');
assert.strictEqual(creationDecision(false, ['wrong-project']), 'PAUSE_UNPROVEN_OR_CONFLICTING');
assert.strictEqual(creationDecision(true, []), 'PENDING');
assert.strictEqual(creationDecision(true, [], true), 'PAUSE_CREATION_DISPATCH_AMBIGUOUS');
assert.strictEqual(creationDecision(true, ['exact']), 'ADOPT_EXISTING');
assert.strictEqual(creationDecision(true, ['exact', 'exact']), 'PAUSE_UNPROVEN_OR_CONFLICTING');
assert.strictEqual(creationDecision(true, ['wrong-project']), 'PAUSE_UNPROVEN_OR_CONFLICTING');

function nativeActionDecision(action, intentExists, observations, absenceProven = false) {
  assert(['create', 'message', 'archive'].includes(action));
  const exact = observations.filter(item => item === 'exact-effect');
  if (observations.length === 1 && exact.length === 1) return 'CONFIRM_RECEIPT';
  if (observations.length > 0) return 'PAUSE_CONFLICT';
  if (!intentExists) return 'PERSIST_INTENT_THEN_CALL_ONCE';
  return absenceProven ? 'RETRY_SAME_ACTION_KEY' : 'RECONCILE_NO_REPLAY';
}
for (const action of ['create', 'message', 'archive']) {
  assert.strictEqual(nativeActionDecision(action, false, []), 'PERSIST_INTENT_THEN_CALL_ONCE');
  assert.strictEqual(nativeActionDecision(action, true, ['exact-effect']), 'CONFIRM_RECEIPT');
  assert.strictEqual(nativeActionDecision(action, true, []), 'RECONCILE_NO_REPLAY');
  assert.strictEqual(nativeActionDecision(action, true, [], true), 'RETRY_SAME_ACTION_KEY');
  assert.strictEqual(nativeActionDecision(action, true, ['wrong-effect']), 'PAUSE_CONFLICT');
}
const actionIntent = {action_key: 'plan-a:r1:message:E01:1', action: 'message', target_ref: 'executorA', effect_ref: 'handoff-a', grant_source_ref: 'message-a', role: 'executor', project_id: 'project-a', directory_name: null, environment: 'local', adopted_session_ref: null, plan_id: 'plan-a', epoch: 1, result: 'pending'};
assert(validatePlan({...plan, native_action_intents: [actionIntent]}));
assert.throws(() => validatePlan({...plan, native_action_intents: [{...actionIntent, effect_ref: ''}]}));
assert.throws(() => validatePlan({...plan, native_action_intents: [{...actionIntent, action: 'delete'}]}));
const projectlessPlan = {...plan, creation_grant: {...plan.creation_grant, project_id: null, directory_name: 'projectless-output', environments: [null]}};
const projectlessIntent = {...actionIntent, project_id: null, directory_name: 'projectless-output', environment: null};
assert(validatePlan({...projectlessPlan, native_action_intents: [projectlessIntent]}));
assert.throws(() => validatePlan({...projectlessPlan, native_action_intents: [{...projectlessIntent, directory_name: null}]}));
const actionReceipt = {action_key: actionIntent.action_key, action: 'message', target_ref: 'executorA', observed_effect_ref: 'handoff-a', grant_source_ref: 'message-a', epoch: 1, result: 'confirmed', evidence_ref: 'thread-read-a'};
assert(validatePlan({...plan, native_action_receipts: [actionReceipt]}));
assert.throws(() => validatePlan({...plan, native_action_receipts: [{...actionReceipt, evidence_ref: ''}]}));

function bootstrapDecision(intentExists, observed, boundedReconciliationComplete = false) {
  const exact = observed.filter(item => item === 'exact-destination' || item === 'alternate-destination');
  if (intentExists && observed.length === 1 && exact.length === 1) return 'ADOPT';
  if (observed.length > 0) return 'PAUSE_UNPROVEN_OR_CONFLICTING';
  if (!intentExists) return 'WRITE_BOOTSTRAP_INTENT_AND_CREATE_ONCE';
  return boundedReconciliationComplete ? 'PAUSE_BOOTSTRAP_DISPATCH_AMBIGUOUS' : 'PENDING';
}
assert.strictEqual(bootstrapDecision(false, []), 'WRITE_BOOTSTRAP_INTENT_AND_CREATE_ONCE');
assert.strictEqual(bootstrapDecision(false, ['exact-destination']), 'PAUSE_UNPROVEN_OR_CONFLICTING');
assert.strictEqual(bootstrapDecision(true, []), 'PENDING');
assert.strictEqual(bootstrapDecision(true, [], true), 'PAUSE_BOOTSTRAP_DISPATCH_AMBIGUOUS');
assert.strictEqual(bootstrapDecision(true, ['exact-destination']), 'ADOPT');
assert.strictEqual(bootstrapDecision(true, ['alternate-destination']), 'ADOPT');
assert.strictEqual(bootstrapDecision(true, ['exact-destination', 'alternate-destination']), 'PAUSE_UNPROVEN_OR_CONFLICTING');
assert.strictEqual(bootstrapDecision(true, ['wrong-project']), 'PAUSE_UNPROVEN_OR_CONFLICTING');

function reviewClass(effect, secondOrthogonalDomain = false) {
  const material = new Set(['product', 'code', 'security', 'privacy', 'data', 'migration', 'public']);
  if (secondOrthogonalDomain) return 'specialist';
  return material.has(effect) ? 'independent' : 'targeted';
}
assert.strictEqual(reviewClass('code'), 'independent');
assert.strictEqual(reviewClass('security'), 'independent');
assert.strictEqual(reviewClass('documentation'), 'targeted');
assert.strictEqual(reviewClass('code', true), 'specialist');

function mustPause(reason) { return pauseReasons.has(reason); }
for (const reason of pauseReasons) assert(mustPause(reason));
for (const warning of ['missing-structured-content', 'incomplete-response', 'display-drift', 'tool-incident', 'recoverable-write']) assert(!mustPause(warning));

function grantCovers(grant, actor, action, planId) {
  const identity = grant.project_id === null ? actor.project_id === null && grant.directory_name === actor.directory_name : grant.project_id === actor.project_id;
  const provenance = actor.adopted_session_ref === null || grant.adopted_session_refs.includes(actor.adopted_session_ref);
  return grant.plan_id === planId && grant.actions.includes(action) && identity && grant.environments.includes(actor.environment) && grant.roles.includes(actor.role) && provenance;
}
const grantActor = {project_id: 'project-a', directory_name: null, environment: 'local', role: 'executor', adopted_session_ref: null};
assert(grantCovers(plan.creation_grant, grantActor, 'message', 'plan-a'));
assert(!grantCovers(plan.creation_grant, grantActor, 'message', 'plan-b'));
assert(!grantCovers(plan.creation_grant, grantActor, 'delete', 'plan-a'));
assert(!grantCovers(plan.creation_grant, {...grantActor, project_id: 'project-b'}, 'message', 'plan-a'));
assert(!grantCovers(plan.creation_grant, {...grantActor, role: 'planner'}, 'message', 'plan-a'));
assert(!grantCovers(plan.creation_grant, {...grantActor, adopted_session_ref: 'adopted-a'}, 'message', 'plan-a'));
assert(grantCovers({...plan.creation_grant, adopted_session_refs: ['adopted-a']}, {...grantActor, adopted_session_ref: 'adopted-a'}, 'message', 'plan-a'));

function beginReplan(previous) {
  return {...previous, status: 'replanning', proposed_revision: previous.approved_revision + 1, proposed_review: null, acceptedPasses: []};
}
const replanned = beginReplan({...plan, acceptedPasses: ['pass-a']});
assert.strictEqual(replanned.approved_revision, 1);
assert.strictEqual(replanned.proposed_revision, 2);
assert.deepStrictEqual(replanned.acceptedPasses, []);
assert.strictEqual(replanned.proposed_review, null);

function eligibleSafeReady(tasks, capacity, active = []) {
  const occupied = new Set(active.flatMap(task => task.conflicts));
  const eligible = tasks
    .filter(task => task.ready && task.authorized && task.routeAvailable && task.withinBudget && !task.gateBlocked)
    .sort((a, b) => a.criticalRank - b.criticalRank);
  const selected = [];
  for (const task of eligible) {
    if (selected.length >= capacity) break;
    if (task.conflicts.some(key => occupied.has(key))) continue;
    selected.push(task);
    task.conflicts.forEach(key => occupied.add(key));
  }
  return selected.map(task => task.ref);
}
const frontier = [
  {ref: 'E01', criticalRank: 1, ready: true, authorized: true, routeAvailable: true, withinBudget: true, gateBlocked: false, conflicts: ['file:a']},
  {ref: 'E02', criticalRank: 2, ready: true, authorized: true, routeAvailable: true, withinBudget: true, gateBlocked: false, conflicts: ['file:b']},
  {ref: 'E03', criticalRank: 3, ready: true, authorized: true, routeAvailable: true, withinBudget: true, gateBlocked: false, conflicts: ['file:c']},
  {ref: 'E04', criticalRank: 4, ready: true, authorized: true, routeAvailable: true, withinBudget: true, gateBlocked: false, conflicts: ['file:a']},
  {ref: 'E05', criticalRank: 5, ready: true, authorized: true, routeAvailable: true, withinBudget: true, gateBlocked: true, conflicts: ['file:d']}
];
assert.deepStrictEqual(eligibleSafeReady(frontier, 2), ['E01', 'E02']);
assert.deepStrictEqual(eligibleSafeReady(frontier.slice(2), 1), ['E03']);
assert.deepStrictEqual(eligibleSafeReady(frontier, 2, [{conflicts: ['file:a']}]), ['E02', 'E03']);

function correctionDecision(history, findingKey) {
  const repeats = history.filter(item => item.verdict === 'REVISE' && item.findingKey === findingKey).length;
  return repeats >= 2 ? 'DIAGNOSE_PLAN_TOOL_VERIFIER_ROUTE' : 'TARGETED_CORRECTION';
}
assert.strictEqual(correctionDecision([{verdict: 'REVISE', findingKey: 'stable-a'}], 'stable-a'), 'TARGETED_CORRECTION');
assert.strictEqual(correctionDecision([{verdict: 'REVISE', findingKey: 'stable-a'}, {verdict: 'REVISE', findingKey: 'stable-a'}], 'stable-a'), 'DIAGNOSE_PLAN_TOOL_VERIFIER_ROUTE');

function observableBudgets(telemetry) {
  const result = {};
  for (const key of ['tokens', 'tool_calls', 'compactions']) if (telemetry[key] === true) result[key] = 1;
  return result;
}
assert.deepStrictEqual(observableBudgets({tokens: false, tool_calls: true, compactions: false}), {tool_calls: 1});
assert.deepStrictEqual(observableBudgets({}), {});

function needsNewHumanGo(change) {
  return ['scope', 'target', 'risk', 'newProtectedAction'].some(key => change[key] === true);
}
assert.strictEqual(needsNewHumanGo({technicalHeadChanged: true, content: true, effectiveDiff: true, blockingReview: true, requiredValidation: true}), false);
assert.strictEqual(needsNewHumanGo({scope: true}), true);
assert.strictEqual(needsNewHumanGo({target: true}), true);
assert.strictEqual(needsNewHumanGo({risk: true}), true);
assert.strictEqual(needsNewHumanGo({newProtectedAction: true}), true);

function recoveryDecision(incident, proposedRemedy = null) {
  assert(typeof incident.key === 'string' && incident.key.length > 0);
  if (incident.previousKey && incident.previousKey !== incident.key) return 'REJECT_KEY_RESET';
  if (incident.unsafe || incident.protectedAction || incident.scopeChanged || incident.targetChanged || incident.riskChanged) return 'STOP_IMMEDIATELY';
  const attempts = new Set((incident.attempts || []).map(item => item.remedyKey));
  if ((incident.receipts || []).some(item => item.result === 'confirmed')) return 'RESUME';
  if (!proposedRemedy) return attempts.size >= 2 ? 'PAUSE_EXHAUSTED' : 'PROPOSE_SAFE_REMEDY';
  if (attempts.has(proposedRemedy)) return 'NO_REPLAY_OR_RESET';
  return attempts.size >= 2 ? 'PAUSE_EXHAUSTED' : 'TRY_AND_RECEIPT';
}
const incident = {key: 'incident-a', attempts: []};
assert.strictEqual(recoveryDecision(incident), 'PROPOSE_SAFE_REMEDY');
assert.strictEqual(recoveryDecision(incident, 'repair-a'), 'TRY_AND_RECEIPT');
const once = {...incident, attempts: [{remedyKey: 'repair-a'}]};
assert.strictEqual(recoveryDecision({...once, wake: true, wording: 'changed'}, 'repair-a'), 'NO_REPLAY_OR_RESET');
assert.strictEqual(recoveryDecision(once, 'repair-b'), 'TRY_AND_RECEIPT');
const exhausted = {...incident, attempts: [{remedyKey: 'repair-a'}, {remedyKey: 'repair-b'}]};
assert.strictEqual(recoveryDecision(exhausted), 'PAUSE_EXHAUSTED');
assert.strictEqual(recoveryDecision(exhausted, 'repair-c'), 'PAUSE_EXHAUSTED');
assert.strictEqual(recoveryDecision({...once, receipts: [{result: 'confirmed'}]}), 'RESUME');
assert.strictEqual(recoveryDecision({...once, unsafe: true}), 'STOP_IMMEDIATELY');
assert.strictEqual(recoveryDecision({...once, protectedAction: true}), 'STOP_IMMEDIATELY');
assert.strictEqual(recoveryDecision({...once, previousKey: 'incident-original', key: 'incident-reworded'}), 'REJECT_KEY_RESET');

console.log('PASS: Octoplan 12 outcome-first fixtures');
NODE

grep -q '^### 12\.1\.0 — 2026-08-11$' "$changelog" || fail 'Codex changelog lacks 12.1.0'

printf 'PASS: Octoplan Codex 12.1.0 contract\n'
