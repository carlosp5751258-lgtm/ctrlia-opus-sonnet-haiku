# ctrlia-opus-sonnet-haiku

Prueba reproducible para comparar **Opus 5.5, Sonnet 5.5 y Haiku 5.5** (y, opcionalmente, Fable 5.1) en Claude Code con la misma tarea: arreglar un bug de redondeo y añadir una función con tests en un proyecto Python pequeño. Mide tiempo, coste estimado y calidad con pruebas ocultas que el modelo no ve.

**Estado: metodología lista; resultados pendientes.** Ejecutar la prueba cuesta dinero (ver abajo).

Página con la explicación completa y la tabla de decisión:
- Español: https://ctrlia.dev/recetas/opus-sonnet-haiku.html
- English: https://ctrlia.dev/en/recetas/opus-sonnet-haiku.html

Probado con Claude Code **2.1.316**.

## Qué hay aquí

| Archivo | Para qué |
| --- | --- |
| `TAREA.md` | El prompt, idéntico para todos los modelos |
| `plantilla/` | El proyecto de partida (con el bug a propósito en `src/precios.py`) |
| `ocultas/test_ocultas.py` | 7 pruebas ocultas que se copian al final para medir la calidad |
| `medir.sh` | Una ejecución: `./medir.sh <modelo> <effort> <repeticion>` → una línea en `resultados.jsonl` |
| `lote.sh` | `./lote.sh humo` (3 ejecuciones) o `./lote.sh completa` (18) y el resumen |

## Cómo usarlo

Requisitos: Claude Code 2.1.316, git, python3 con pytest, jq y una clave `ANTHROPIC_API_KEY` (necesaria para `--bare`, que no carga hooks, skills ni CLAUDE.md de tu equipo).

```bash
git clone https://github.com/carlosp5751258-lgtm/ctrlia-opus-sonnet-haiku
cd ctrlia-opus-sonnet-haiku
export ANTHROPIC_API_KEY=...   # la tuya; no la guardes en el repositorio
./lote.sh humo                 # fase 1: 3 ejecuciones (≈ 0,5-1,5 USD)
./lote.sh completa             # fase 2: 18 ejecuciones (≈ 3 USD realista, 8,8 USD de cota alta)
```

Cada ejecución arranca en una carpeta temporal nueva, con `--permission-mode dontAsk`, una lista cerrada de herramientas y topes `--max-budget-usd 2` y `--max-turns 40` (peor caso: 36 USD para 18 ejecuciones). Para añadir Fable 5.1, edita la variable `modelos` de `lote.sh` (hasta 23,2 USD de cota alta).

Con una suscripción en vez de clave de API, `--bare` no sirve: tendrías que quitarlo y aislar tu configuración, el coste sería una estimación y gastarías límite del plan.

## Licencia

MIT. Ver [LICENSE](LICENSE).
