from src.prices import total_with_vat

def test_vat_rounds_half_up():
    # 10.125 € net at 0 % VAT must end up as 10.13 (ROUND_HALF_UP), not 10.12
    assert total_with_vat(10.125, 0) == 10.13

def test_normal_vat():
    assert total_with_vat(100, 0.21) == 121.0
