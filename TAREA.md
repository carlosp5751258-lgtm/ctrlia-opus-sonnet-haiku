Estás en un proyecto Python pequeño (carpeta src/ y tests/).
1. Ejecuta `python3 -m pytest -q` y arregla el fallo de `tests/test_precios.py` sin tocar los tests.
2. Añade a `src/precios.py` la función `aplicar_cupon(total, codigo)` con estas reglas:
   - "BIENVENIDA" resta un 10 %; "ENVIO" resta 4,99 si el total es de al menos 30; cualquier otro código lanza ValueError.
   - El resultado nunca baja de 0 y se redondea a 2 decimales con ROUND_HALF_UP del módulo decimal (no con round()).
3. Escribe tests para `aplicar_cupon` en `tests/test_cupon.py`.
4. Termina cuando `python3 -m pytest -q` pase entero. No instales paquetes ni uses la red.
