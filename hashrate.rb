require 'digest'
require 'pp'


def compute_hash_with_proof_of_work( data, difficulty='00' )
  nonce = 0
  loop do
    hash = Digest::SHA256.hexdigest( "#{nonce}#{data}" )
    if hash.start_with?( difficulty )
      return [nonce,hash]    ## bingo! proof of work if hash starts with leading zeros (00)
    else
      nonce += 1             ## keep trying (and trying and trying)
    end
  end # loop
end # method compute_hash_with_proof_of_work


(1..7).each do |factor|
   difficulty = '0' * factor
   puts "Difficulty: #{difficulty} (#{difficulty.length*4} bits)"
end


(1..6).each do |factor|
   difficulty = '0' * factor
   puts "Difficulty: #{difficulty} (#{difficulty.length*4} bits)"

   puts "Starting search..."
   t1 = Time.now
   nonce, hash = compute_hash_with_proof_of_work( 'Hello, Cryptos!', difficulty )
   t2 = Time.now

   delta = t2 - t1
   puts "Elapsed Time: %.4f seconds, Hashes Calculated: %d" % [delta,nonce]

   if delta > 0
     hashrate = Float( nonce / delta )
     puts "Hash Rate: %d hashes per second" % hashrate
   end
   puts
end
