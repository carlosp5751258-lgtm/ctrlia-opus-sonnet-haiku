#!/usr/bin/env bash
# measure.sh — one run of the test: ./measure.sh <model> <effort> <repetition>
# Requires: claude 2.1.316, git, python3 with pytest, jq. Recommended mode: --bare with ANTHROPIC_API_KEY.
# Costs money: each run is capped at 2 USD (--max-budget-usd 2).
set -euo pipefail
[ $# -eq 3 ] || { echo "Usage: $0 <model> <effort> <repetition>" >&2; exit 2; }
model="$1"; effort="$2"; rep="$3"
root="$(cd "$(dirname "$0")" && pwd)"
dir="$(mktemp -d /tmp/model-test.XXXXXX)"
cp -r "$root/template/." "$dir/"
cd "$dir"
git init -q && git add -A && git -c user.name=test -c user.email=test@local commit -qm base

start=$(date +%s)
claude --bare -p "$(cat "$root/TASK.md")" \
  --model "$model" --effort "$effort" \
  --permission-mode dontAsk \
  --allowedTools "Read" "Edit" "Bash(python3 -m pytest *)" \
  --max-budget-usd 2 --max-turns 40 \
  --no-session-persistence \
  --output-format json > result.json || true
end=$(date +%s)
[ -s result.json ] || echo '{"is_error": true}' > result.json   # if claude wrote nothing, the row is marked as an error

# Quality: hidden tests the model hasn't seen
cp "$root/hidden/test_hidden.py" tests/
if python3 -m pytest -q tests/test_hidden.py > hidden.txt 2>&1; then hidden=ok; else hidden=fail; fi
passed=$(grep -Eo '[0-9]+ passed' hidden.txt | grep -Eo '[0-9]+' || echo 0)
lines=$(git diff --shortstat HEAD -- src | grep -Eo '[0-9]+ insertion' | grep -Eo '[0-9]+' || echo 0)

jq -c --arg m "$model" --arg e "$effort" --arg r "$rep" --arg o "$hidden" \
      --arg p "$passed" --arg l "$lines" --arg s "$((end-start))" \
  '{model:$m, effort:$e, rep:($r|tonumber), cost_usd:.total_cost_usd,
    ms:.duration_ms, ms_api:.duration_api_ms, turns:.num_turns, error:.is_error,
    hidden:$o, hidden_passed:($p|tonumber), src_lines:($l|tonumber), wall_seconds:($s|tonumber),
    per_model:.modelUsage}' result.json | tee -a "$root/results.jsonl"
echo "Run folder: $dir"
