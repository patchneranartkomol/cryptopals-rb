# frozen_string_literal: true

def hex_to_base64(hexd)
  [[hexd].pack('H*')].pack('m0')
end
