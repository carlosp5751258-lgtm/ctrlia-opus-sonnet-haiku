import pytest
from src.prices import apply_coupon, total_with_vat

def test_welcome():               assert apply_coupon(50, "WELCOME") == 45.0
def test_shipping_minimum():      assert apply_coupon(30, "SHIPPING") == 25.01
def test_shipping_below():        assert apply_coupon(29.99, "SHIPPING") == 29.99
def test_never_negative():        assert apply_coupon(0, "WELCOME") == 0
def test_round_half_up():         assert apply_coupon(0.05, "WELCOME") == 0.05  # 0.045 -> 0.05
def test_invalid_code():
    with pytest.raises(ValueError): apply_coupon(10, "FAKE")
def test_vat_still_right():       assert total_with_vat(2.675, 0) == 2.68
