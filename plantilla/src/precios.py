from decimal import Decimal


def total_con_iva(neto, iva=0.21):
    return round(neto * (1 + iva), 2)
