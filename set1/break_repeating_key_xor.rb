## Implementation of Break repeating-key XOR
# https://cryptopals.com/sets/1/challenges/6

require 'base64'

def edit_distance(sta, stb)
  dist = 0
  a = sta.split('')
  b = stb.split('')
  a.zip(b).map do |x, y|
    dist += diff_bits(x.ord, y.ord)
  end
  dist
end

def diff_bits(x_byte, y_byte)
  d = 0
  while x_byte.positive? || y_byte.positive?
    d += 1 if (x_byte & 1) != (y_byte & 1)
    x_byte >>= 1
    y_byte >>= 1
  end
  d
end

def transpose_blocks(blocks, keysize)
  transposed = []
  (0...keysize).each do |i|
    tblock = ''
    blocks.each do |b|
      break if i >= b.length

      tblock << b[i]
    end
    transposed.push(tblock)
  end
  transposed
end

def check_xor(bytes)
  max_freq = 0
  key_char = ''
  (' '..'z').each do |char|
    decoded = bytes.map { |x| (x ^ char.ord).chr }
    count = 0
    # Check most common English letters. Matches better than [[:alpha]] chars.
    decoded.each { |c| count += 1 if 'ETAOIN SHRDLUWetaoinshrdluw'.include? c }
    max_freq = count if count > max_freq
    key_char = char if max_freq == count
  end
  key_char
end

def decrypt_block(t_block, key)
  decoded = t_block.bytes.map { |byt| (byt ^ key.ord).chr }
  decoded.join('')
end

def chunk(input, size)
  input.chars.each_slice(size).map(&:join)
end

def join_decrypted(blocks)
  out = ''
  blocks[0].length.times do |j|
    blocks.length.times { |i| out << blocks[i][j] if j < blocks[i].length }
  end
  out
end

if __FILE__ == $PROGRAM_NAME
  raise 'edit_distance function failed assertion' \
    unless edit_distance('this is a test', 'wokka wokka!!!') == 37

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
    key_dists.push({ k: keysize, avg: dists.reduce(:+) / dists.size })
  end
  key_dists.sort_by! { |r| r[:avg] }

  # Take the most likely KEYSIZE
  ks = key_dists[0][:k]
  blocks = chunk(encoded, ks)
  transposed = transpose_blocks(blocks, ks)
  key = ''
  transposed.each { |t| key << check_xor(t.bytes) }
  puts "KEY: '#{key}'"
  decrypted = []
  key.length.times do |i|
    decrypted.push(decrypt_block(transposed[i], key[i]))
  end
  puts "Decrypted output:\n#{join_decrypted(decrypted)}"
end
