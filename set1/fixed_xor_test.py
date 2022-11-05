from unittest import TestCase

from fixed_xor import fixed_xor


class Challenge2Test(TestCase):
    def test_fixed_xor(self) -> None:
        self.assertEqual(fixed_xor("1c0111001f010100061a024b53535009181c", "686974207468652062756c6c277320657965"),
            "746865206b696420646f6e277420706c6179")
