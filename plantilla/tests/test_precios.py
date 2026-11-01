from src.precios import total_con_iva

def test_iva_redondeo_hacia_arriba():
    # 10.125 € netos al 0 % de IVA deben quedar en 10.13 (ROUND_HALF_UP), no en 10.12
    assert total_con_iva(10.125, 0) == 10.13

def test_iva_normal():
    assert total_con_iva(100, 0.21) == 121.0

