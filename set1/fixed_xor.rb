# frozen_string_literal: true

def fixed_xor(ahex, bhex)
  a = [ahex].pack('H*').bytes
  b = [bhex].pack('H*').bytes
  out = a.zip(b).map { |x, y| x ^ y }
  out.pack('c*').unpack1('H*')
end
