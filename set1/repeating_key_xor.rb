def repeating_key_xor_encode(msg, key)
  out = []
  i = 0
  chars = msg.split('')
  chars.each do |ch|
    out.push(ch.ord ^ key[i].ord)
    i += 1
    if i == key.length
      i = 0
    end
  end
  out.pack("c*").unpack1("H*")
end
