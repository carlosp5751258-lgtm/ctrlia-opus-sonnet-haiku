You are in a small Python project (src/ and tests/ folders).
1. Run `python3 -m pytest -q` and fix the failure in `tests/test_prices.py` without touching the tests.
2. Add to `src/prices.py` the function `apply_coupon(total, code)` with these rules:
   - "WELCOME" takes 10 % off; "SHIPPING" takes 4.99 off if the total is at least 30; any other code raises ValueError.
   - The result never goes below 0 and is rounded to 2 decimals with ROUND_HALF_UP from the decimal module (not with round()).
3. Write tests for `apply_coupon` in `tests/test_coupon.py`.
4. Finish when `python3 -m pytest -q` passes completely. Don't install packages or use the network.
