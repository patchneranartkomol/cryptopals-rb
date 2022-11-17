# frozen_string_literal: true

require_relative  'cbc_mode'

DETECTION_INPUT = 'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA'.bytes

def gen_random_bytes(size)
  bytes = []
  size.times { bytes << rand(256) }
  bytes
end

def encryption_oracle(input)
  key = gen_random_bytes(16).pack('c*')
  target = gen_random_bytes(rand(5..10)) + input + gen_random_bytes(rand(5..10))
  mode = rand(2)
  case mode
  when 0
    puts "ecb" # Quick and dirty spot check of detection oracle
    encrypt_aes_ecb(key, target)
  else
    puts "cbc"
    encrypt_aes_cbc(key, target, gen_random_bytes(16))
  end
end

def detection_oracle(e_oracle)
  encrypted = e_oracle.call(DETECTION_INPUT)
  encrypted[20, 16] == encrypted[36, 16]
end

15.times { puts detection_oracle(method(:encryption_oracle)) } if __FILE__ == $PROGRAM_NAME
