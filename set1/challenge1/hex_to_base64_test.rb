require_relative "hex_to_base64"
require 'test/unit'

class MyTest < Test::Unit::TestCase
  def test_conversion
    # Hex represents bytes for "I'm killing your brain like a poisonous mushroom" in ASCII/UTF-8
    assert_equal(hex_to_base64("49276d206b696c6c696e6720796f757220627261696e206c696b65206120706f69736f6e6f7573206d757368726f6f6d"), "SSdtIGtpbGxpbmcgeW91ciBicmFpbiBsaWtlIGEgcG9pc29ub3VzIG11c2hyb29t")
  end
end
