# ctrlia-opus-sonnet-haiku

A reproducible test to compare **Opus 5.5, Sonnet 5.5 and Haiku 5.5** (and, optionally, Fable 5.1) in Claude Code on the same task: fix a rounding bug and add a function with tests in a small Python project. It measures time, estimated cost and quality with hidden tests the model never sees.

**Status: methodology ready; results pending.** Running the test costs money (see below).

Page with the full explanation and the decision table:
- English: https://ctrlia.dev/en/recetas/opus-sonnet-haiku.html
- Español: https://ctrlia.dev/recetas/opus-sonnet-haiku.html

Tested with Claude Code **2.1.316**. The prompt and the scripts are in Spanish.

## What's here

| File | What for |
| --- | --- |
| `TAREA.md` | The prompt, identical for every model |
| `plantilla/` | The starting project (with the intentional bug in `src/precios.py`) |
| `ocultas/test_ocultas.py` | 7 hidden tests copied in at the end to measure quality |
| `medir.sh` | One run: `./medir.sh <model> <effort> <repetition>` → one line in `resultados.jsonl` |
| `lote.sh` | `./lote.sh humo` (smoke, 3 runs) or `./lote.sh completa` (full, 18) and the summary |

## How to use it

Requirements: Claude Code 2.1.316, git, python3 with pytest, jq and an `ANTHROPIC_API_KEY` (needed for `--bare`, which loads no hooks, skills or CLAUDE.md from your machine).

```bash
git clone https://github.com/carlosp5751258-lgtm/ctrlia-opus-sonnet-haiku
cd ctrlia-opus-sonnet-haiku
export ANTHROPIC_API_KEY=...   # your own; do not save it in the repository
./lote.sh humo                 # phase 1: 3 runs (≈ 0.5-1.5 USD)
./lote.sh completa             # phase 2: 18 runs (≈ 3 USD realistic, 8.8 USD upper bound)
```

Each run starts in a fresh temporary folder, with `--permission-mode dontAsk`, a closed list of tools and caps of `--max-budget-usd 2` and `--max-turns 40` (worst case: 36 USD for 18 runs). To add Fable 5.1, edit the `modelos` variable in `lote.sh` (up to 23.2 USD upper bound).

With a subscription instead of an API key, `--bare` does not work: you would have to remove it and isolate your configuration, the cost would be an estimate and you would spend plan limit.

## License

MIT. See [LICENSE](LICENSE).
