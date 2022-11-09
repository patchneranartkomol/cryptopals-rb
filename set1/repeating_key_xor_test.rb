# frozen_string_literal: true

require_relative 'repeating_key_xor'
require 'test/unit'

class Challenge5Test < Test::Unit::TestCase
  def test_repeating_key_xor
    assert_equal(repeating_key_xor_encode("Burning 'em, if you ain't quick and nimble\n" \
      'I go crazy when I hear a cymbal', 'ICE'),
                 '0b3637272a2b2e63622c2e69692a23693a2a3c6324202d623d63343c2a26226324272765272' \
                 'a282b2f20430a652e2c652a3124333a653e2b2027630c692b20283165286326302e27282f')
  end
end
