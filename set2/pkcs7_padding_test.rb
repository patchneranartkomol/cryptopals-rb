# frozen_string_literal: true

require_relative 'pkcs7_padding'
require 'test/unit'

class Challenge9Test < Test::Unit::TestCase
  def test_pkcs7_padding
    assert_equal(pkcs7_padding('YELLOW SUBMARINE', 20),
                 "YELLOW SUBMARINE\x04\x04\x04\x04")
  end
end
