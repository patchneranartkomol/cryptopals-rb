# frozen_string_literal: true

require_relative  'cbc_mode'
require_relative  'ecb_cbc_detection_oracle'
require 'base64'

RAND_KEY = gen_random_bytes(16).pack('c*')
ENCODED_STR = 'Um9sbGluJyBpbiBteSA1LjAKV2l0aCBteSByYWctdG9wIGRvd24gc28gbXkga'\
'GFpciBjYW4gYmxvdwpUaGUgZ2lybGllcyBvbiBzdGFuZGJ5IHdhdmluZyBqdXN0IHRvIHNheSBoa'\
'QpEaWQgeW91IHN0b3A/IE5vLCBJIGp1c3QgZHJvdmUgYnkK'
UNKNOWN_STR = Base64.decode64(ENCODED_STR)

def encryption_oracle(input)
  encrypt_aes_ecb(RAND_KEY, input + UNKNOWN_STR.bytes)
end

def detect_ecb_blocksize(blocksize)
  blocks = []
  input = encryption_oracle(('A' * blocksize * 2).bytes)
  input.each_slice(blocksize) { |slice| blocks.append(slice) }
  #  n-byte plaintext block encrypted with AES ECB will always produce
  #  the same n-byte ciphertext.
  blocks[0] == blocks[1]
end

def decrypt_char(decoded_msg, blocksize)
  size = (decoded_msg.length / blocksize + 1) * blocksize # Current size of msg in 16-byte increments
  # 'AAA...' padding for block
  prefix = Array.new(size - decoded_msg.length - 1, 'A'.ord)
  target = encryption_oracle(prefix).slice(0, size)
  brute_force_chars(prefix + decoded_msg, target, size)
end

def brute_force_chars(input, target, size)
  # Printable ASCII chars
  10.upto(128) do |byte|
    # Encode 'AAA..' + decoded bytes + 'x'; to brute force 'x'
    output = encryption_oracle(input + [byte])
    return byte if output[0, size] == target
  end
end

if __FILE__ == $PROGRAM_NAME
  blocksize = -1
  1.upto(30) do |i|
    blocksize = detect_ecb_blocksize(i) ? i : blocksize
  end

  decoded_msg = []
  UNKNOWN_STR.length.times { decoded_msg << decrypt_char(decoded_msg, blocksize) }
  puts decoded_msg.pack('c*')
end
