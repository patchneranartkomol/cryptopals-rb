# frozen_string_literal: true

def pkcs7_padding(string, blocksize)
  input_bytes = string.bytes
  padding_size = blocksize - (input_bytes.length % blocksize)
  input_bytes += Array.new(padding_size, 0x04)
  input_bytes.pack('c*')
end
