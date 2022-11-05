def fixed_xor(ahex: str, bhex: str) -> str:
    a = bytes.fromhex(ahex)
    b = bytes.fromhex(bhex)
    return bytes((x ^ y for x, y in zip(a, b))).hex()
