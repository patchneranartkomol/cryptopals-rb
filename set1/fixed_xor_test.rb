require_relative "fixed_xor"
require 'test/unit'

class Challenge2Test < Test::Unit::TestCase
  def test_fixed_xor
    assert_equal(fixed_xor("1c0111001f010100061a024b53535009181c", "686974207468652062756c6c277320657965"), "746865206b696420646f6e277420706c6179")
  end
end
