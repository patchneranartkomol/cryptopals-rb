# frozen_string_literal: true

$max_score = 0
$result = ''

def determine_message(s)
  b = [s].pack('H*').bytes
  ('A'..'Z').each { |ch| check_xor(ch, b) }
  ('a'..'z').each { |ch| check_xor(ch, b) }
end

def check_xor(ch, b)
  decoded = b.map { |x| (x ^ ch.ord).chr }
  count = 0
  decoded.each do |x|
    count += 1 if 'ETAOIN SHRDLUetaoinshrdlu'.include? x
  end
  return unless count > $max_score

  $max_score = count
  $res = decoded.join('')
end

if __FILE__ == $PROGRAM_NAME
  determine_message('1b37373331363f78151b7f2b783431333d78397828372d363c78373e783a393b3736')
  puts $res
end
