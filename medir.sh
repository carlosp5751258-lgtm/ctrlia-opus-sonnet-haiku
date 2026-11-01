#!/usr/bin/env bash
# medir.sh — una ejecución de la prueba: ./medir.sh <modelo> <effort> <repeticion>
# Requiere: claude 2.1.316, git, python3 con pytest, jq. Modo recomendado: --bare con ANTHROPIC_API_KEY.
# Cuesta dinero: cada ejecución tiene un tope de 2 USD (--max-budget-usd 2).
set -euo pipefail
[ $# -eq 3 ] || { echo "Uso: $0 <modelo> <effort> <repeticion>" >&2; exit 2; }
modelo="$1"; effort="$2"; rep="$3"
raiz="$(cd "$(dirname "$0")" && pwd)"
dir="$(mktemp -d /tmp/prueba-modelos.XXXXXX)"
cp -r "$raiz/plantilla/." "$dir/"
cd "$dir"
git init -q && git add -A && git -c user.name=prueba -c user.email=prueba@local commit -qm base

inicio=$(date +%s)
claude --bare -p "$(cat "$raiz/TAREA.md")" \
  --model "$modelo" --effort "$effort" \
  --permission-mode dontAsk \
  --allowedTools "Read" "Edit" "Bash(python3 -m pytest *)" \
  --max-budget-usd 2 --max-turns 40 \
  --no-session-persistence \
  --output-format json > resultado.json || true
fin=$(date +%s)
[ -s resultado.json ] || echo '{"is_error": true}' > resultado.json   # si claude no escribió nada, la fila queda marcada como error

# Calidad: pruebas ocultas que el modelo no ha visto
cp "$raiz/ocultas/test_ocultas.py" tests/
if python3 -m pytest -q tests/test_ocultas.py > ocultas.txt 2>&1; then ocultas=ok; else ocultas=fallo; fi
pasan=$(grep -Eo '[0-9]+ passed' ocultas.txt | grep -Eo '[0-9]+' || echo 0)
lineas=$(git diff --shortstat HEAD -- src | grep -Eo '[0-9]+ insertion' | grep -Eo '[0-9]+' || echo 0)

jq -c --arg m "$modelo" --arg e "$effort" --arg r "$rep" --arg o "$ocultas" \
      --arg p "$pasan" --arg l "$lineas" --arg s "$((fin-inicio))" \
  '{modelo:$m, effort:$e, rep:($r|tonumber), coste_usd:.total_cost_usd,
    ms:.duration_ms, ms_api:.duration_api_ms, turnos:.num_turns, error:.is_error,
    ocultas:$o, ocultas_pasan:($p|tonumber), lineas_src:($l|tonumber), segundos_reloj:($s|tonumber),
    por_modelo:.modelUsage}' resultado.json | tee -a "$raiz/resultados.jsonl"
echo "Carpeta de la ejecución: $dir"
