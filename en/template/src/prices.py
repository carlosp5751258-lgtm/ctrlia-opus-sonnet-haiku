from decimal import Decimal


def total_with_vat(net, vat=0.21):
    return round(net * (1 + vat), 2)
