#!/usr/bin/env bash
# lote.sh — fase 1 (humo, 3 ejecuciones, ~0,5-1,5 USD): ./lote.sh humo   · fase 2 (18 ejecuciones): ./lote.sh completa
# Cuesta dinero. Revisa resultados.jsonl tras la fase de humo antes de lanzar la completa.
set -euo pipefail
cd "$(dirname "$0")"
modelos="claude-haiku-5-5 claude-sonnet-5-5 claude-opus-5-5"   # Fable 5.1 solo si se aprueba aparte: añadir "fable"
case "${1:-humo}" in
  humo) for m in $modelos; do ./medir.sh "$m" medium 1; done ;;
  completa) for rep in 1 2 3; do for e in medium high; do for m in $modelos; do ./medir.sh "$m" "$e" "$rep"; done; done; done ;;
  *) echo "Uso: $0 [humo|completa]" >&2; exit 2 ;;
esac
# Resumen por modelo y effort: media de coste y segundos, mediana de pruebas ocultas superadas (de 7)
jq -s 'group_by(.modelo+"/"+.effort) | map({clave:(.[0].modelo+"/"+.[0].effort),
  n:length, coste_medio:(map(.coste_usd // 0)|add/length), seg_medios:(map(.ms // 0)|add/length/1000),
  ocultas_mediana:(map(.ocultas_pasan)|sort|.[length/2|floor]),
  ocultas_ok:(map(select(.ocultas=="ok"))|length), turnos_medios:(map(.turnos // 0)|add/length)})' resultados.jsonl
