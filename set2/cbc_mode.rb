# frozen_string_literal: true

require 'base64'
require 'openssl'

KEY = 'YELLOW SUBMARINE'
TEST_STRING = 'Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur'
IV = Array.new(16, 0x00) # "\x00\x00\x00.."

def decrypt_aes_ecb(key, ciphertext_bytes)
  cipher = OpenSSL::Cipher.new('aes-128-ecb').decrypt
  cipher.key = key

  cipher.update(ciphertext_bytes.pack('c*')) + cipher.final
end

def encrypt_aes_ecb(key, plaintext_bytes)
  cipher = OpenSSL::Cipher.new('aes-128-ecb').encrypt
  cipher.key = key

  (cipher.update(plaintext_bytes.pack('c*')) + cipher.final).bytes
end

def xor_bytes(arr_a, arr_b)
  arr_a.zip(arr_b).map { |x, y| x ^ y }
end

def encrypt_aes_cbc(key, plaintext_bytes, iv)
  cipher = OpenSSL::Cipher.new('aes-128-ecb').encrypt
  cipher.key = key
  prev = iv
  plaintext_bytes.each_slice(16).flat_map do |block|
    prev = cipher.update(xor_bytes(block, prev).pack('c*')).bytes
  end
end

def decrypt_aes_cbc(key, ciphertext_bytes, iv)
  cipher = OpenSSL::Cipher.new('aes-128-ecb').decrypt
  cipher.key = key
  # Without padding, calling cipher.final "bad decrypt" error.
  cipher.padding = 0
  decrypted = cipher.update(ciphertext_bytes.pack('c*')).bytes + cipher.final.bytes
  decrypted.each_slice(16).flat_map.with_index do |block, i|
    xor_bytes(block, i.zero? ? iv : ciphertext_bytes[(i - 1) * 16, 16])
  end.pack('c*')
end

if __FILE__ == $PROGRAM_NAME
  aes_ecb_ciphertext = encrypt_aes_ecb(KEY, TEST_STRING.bytes)
  plaintext = decrypt_aes_ecb(KEY, aes_ecb_ciphertext)
  raise 'AES ECB implementation error' unless plaintext == TEST_STRING

  aes_cbc_bytes = encrypt_aes_cbc(KEY, TEST_STRING.bytes, IV)
  plaintext = decrypt_aes_cbc(KEY, aes_cbc_bytes, IV)
  raise 'AES CBC implementation error' unless plaintext == TEST_STRING

  str = Base64.decode64(File.read('10.txt'))
  puts decrypt_aes_cbc(KEY, str.bytes, IV)
end
