#!/bin/sh
set -eu

root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
skill="$root/plugins/octoplan-codex/skills/octoplan"
runtime="$skill/references/codex-runtime.md"
planning="$skill/references/planning.md"
relay="$skill/references/codex-relay.md"
manifest="$root/plugins/octoplan-codex/.codex-plugin/plugin.json"

fail() {
  printf 'FAIL: %s\n' "$1" >&2
  exit 1
}

grep -q '^Version: 2\.0\.1$' "$skill/SKILL.md" || fail 'SKILL.md is not 2.0.1'
grep -q '"version": "2\.0\.1"' "$manifest" || fail 'plugin manifest is not 2.0.1'

if grep -R -n 'Review: skip\|review is skipped\|review is skipped\|reviewer or directly' \
  "$skill/SKILL.md" "$planning" "$runtime" "$relay" >/dev/null; then
  fail 'an active review-skip path remains'
fi

if grep -q 'durable completion or required review' "$planning"; then
  fail 'parallel continuation can bypass review'
fi

grep -q 'one fresh independent review' "$runtime" || fail 'mandatory fresh review is missing'
grep -q 'one reviewer by default' "$runtime" || fail 'single-review default is missing'
grep -q 'orthogonal' "$runtime" || fail 'orthogonal second-review gate is missing'
grep -q 'Specialist review route' "$planning" || fail 'task template lacks specialist review route'
grep -q 'Specialist review route' "$relay" || fail 'relay lacks specialist review support'
grep -q 'detection difficulty' "$runtime" || fail 'review routing is not detection-based'
grep -q 'immutable artifact revision' "$relay" || fail 'review PASS is not revision-bound'
grep -q 'fresh correction executor and full reviewer set' "$relay" || fail 'reviewer rerouting has no executable recovery path'
grep -q 'why this route;.*mandate' "$planning" || fail 'review routes lack saved rationale and mandate'
grep -q '^Plan review:$' "$planning" || fail 'plan-review routing record is undefined'
grep -q 'create exactly its saved lead and specialist' "$planning" || fail 'plan-review routing record is not read back'

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
grep -Fq 'distinguishes choices the executor must originate from review-only judgment' "$planning" || fail 'mixed-task rationale is not auditable'

printf 'PASS: octoplan-codex routing contract\n'
