import pytest
from src.precios import aplicar_cupon, total_con_iva

def test_bienvenida():            assert aplicar_cupon(50, "BIENVENIDA") == 45.0
def test_envio_minimo():          assert aplicar_cupon(30, "ENVIO") == 25.01
def test_envio_por_debajo():      assert aplicar_cupon(29.99, "ENVIO") == 29.99
def test_nunca_negativo():        assert aplicar_cupon(0, "BIENVENIDA") == 0
def test_redondeo_half_up():      assert aplicar_cupon(0.05, "BIENVENIDA") == 0.05  # 0.045 -> 0.05
def test_codigo_invalido():
    with pytest.raises(ValueError): aplicar_cupon(10, "FALSO")
def test_iva_sigue_bien():        assert total_con_iva(2.675, 0) == 2.68
