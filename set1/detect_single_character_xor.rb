# frozen_string_literal: true

$max_score = 0
$result = ''

def check_message(s)
  b = [s].pack('H*').bytes
  ('0'..'z').each { |ch| check_xor(ch, b) }
end

def check_xor(ch, b)
  decoded = b.map { |x| (x ^ ch.ord).chr }
  count = 0
  decoded.each do |x|
    count += 1 if 'ETAOIN SHRDLUetaoinshrdlu'.include? x
  end
  if count > $max_score
    $max_score = count
    $res = decoded.join('')
  end
  decoded_str = decoded.join('')
end

if __FILE__ == $PROGRAM_NAME
  File.readlines('4.txt').each do |line|
    check_message(line)
  end
  puts $res
end
