#!/usr/bin/env bash
# batch.sh — phase 1 (smoke, 3 runs, ~0.5-1.5 USD): ./batch.sh smoke   · phase 2 (18 runs): ./batch.sh full
# Costs money. Check results.jsonl after the smoke phase before launching the full one.
set -euo pipefail
cd "$(dirname "$0")"
models="claude-haiku-5-5 claude-sonnet-5-5 claude-opus-5-5"   # Fable 5.1 only if approved separately: add "fable"
case "${1:-smoke}" in
  smoke) for m in $models; do ./measure.sh "$m" medium 1; done ;;
  full) for rep in 1 2 3; do for e in medium high; do for m in $models; do ./measure.sh "$m" "$e" "$rep"; done; done; done ;;
  *) echo "Usage: $0 [smoke|full]" >&2; exit 2 ;;
esac
# Summary per model and effort: mean cost and seconds, median of hidden tests passed (out of 7)
jq -s 'group_by(.model+"/"+.effort) | map({key:(.[0].model+"/"+.[0].effort),
  n:length, mean_cost:(map(.cost_usd // 0)|add/length), mean_seconds:(map(.ms // 0)|add/length/1000),
  hidden_median:(map(.hidden_passed)|sort|.[length/2|floor]),
  hidden_ok:(map(select(.hidden=="ok"))|length), mean_turns:(map(.turns // 0)|add/length)})' results.jsonl
