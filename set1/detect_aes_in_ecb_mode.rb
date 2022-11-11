# frozen_string_literal: true

## Detect AES in ECB mode
# https://cryptopals.com/sets/1/challenges/8

def test_blocksize(hex_strs, blocksize)
  hex_strs.each do |str|
    blocks = []
    str.chars.to_a.each_slice(blocksize) { |slice| blocks.append(slice.join('')) }
    return str if blocks.detect { |s| blocks.count(s) > 1 } != nil
  end
end

if __FILE__ == $PROGRAM_NAME
  input = File.readlines('8.txt')
  # Look for matching 16 byte (2 hex chars / byte) pattern in hex-encoded string
  ans = test_blocksize(input, 32)
  puts ans
end
