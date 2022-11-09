require "base64"

def edit_distance(s, t)
  dist = 0
  sa = s.split('')
  ta = t.split('')
  sa.zip(ta).map do |x, y|
    dist += diff_bits(x.ord, y.ord)
  end
  return dist
end

def diff_bits(x, y)
  d = 0
  while x > 0 || y > 0
    if (x & 1) != (y & 1)
      d += 1
    end
    x >>= 1
    y >>= 1
  end
  return d
end

def transpose_blocks(blocks, keysize)
  transposed = []
  (0...keysize).each do |i|
    tblock = ""
    blocks.each do |b|
      if i >= b.length
        break
      end
      tblock << b[i]
    end
    transposed.push(tblock)
  end
  return transposed
end

def check_xor(b)
  max_freq = 0
  key_char = ""
  (' '..'z').each do |char| 
    decoded = b.map { |x| (x ^ char.ord).chr }
    count = 0
    decoded.each do |c|
      if "ETAOIN SHRDLUWetaoinshrdluw".include? c
        count += 1
      end
    end
    if count > max_freq
        max_freq = count
        key_char = char
    end
  end
  return key_char
end

def chunk(input, size)
  input.chars.each_slice(size).map(&:join)
end

if __FILE__ == $0
  raise "edit_distance function failed assertion" unless edit_distance("this is a test", "wokka wokka!!!") == 37

  b64_str = File.readlines('6.txt', chomp: true).join('')
  encoded = Base64.decode64(b64_str)

  # Store { :k => keysize, :avg => normalized_avg_edit_distance }
  key_dists = []
  (2..40).each do |keysize|
    dists = []
    blocks = chunk(encoded, keysize)
    blocks[0...-2].each_with_index do |b, i|
      dists.push(edit_distance(b, blocks[i + 1]).to_f / keysize)
    end
    key_dists.push({:k => keysize, :avg => dists.reduce(:+) / dists.size})
  end
  key_dists.sort_by! { |r| r[:avg] }

  # Take the most likely KEYSIZE
  ks = key_dists[0][:k]
  blocks = chunk(encoded, ks)
  transposed = transpose_blocks(blocks, ks)
  key = ""
  transposed.each { |t| key << check_xor(t.bytes) }
  puts "The key is: '#{key}'"
end
