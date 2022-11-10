# This is the equivalent of:
# openssl aes-128-ecb -d -a -in 7.txt -K  $(echo -n "YELLOW SUBMARINE" | hexdump -v -e '/1 "%02X"')
# https://cryptopals.com/sets/1/challenges/7
# frozen_string_literal: true

require 'openssl'
require 'base64'

if __FILE__ == $PROGRAM_NAME
  cipher = OpenSSL::Cipher.new('aes-128-ecb')
  cipher.decrypt
  cipher.key = 'YELLOW SUBMARINE'

  str = Base64.decode64(File.read('7.txt'))
  decrypted = cipher.update(str) + cipher.final
  puts decrypted
end
