import base64


def hex_to_base64(h: str) -> str:
    return base64.b64encode(bytes.fromhex(h)).decode('utf-8')
