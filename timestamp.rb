require 'digest'
require 'pp'      ## pp = pretty print


class Block
  attr_reader :data
  attr_reader :prev
  attr_reader :difficulty
  attr_reader :time
  attr_reader :nonce  # number used once - lucky (mining) lottery number

  def hash
    Digest::SHA256.hexdigest( "#{nonce}#{time}#{difficulty}#{prev}#{data}" )
  end

  def initialize(data, prev, difficulty: '0000' )
    @data         = data
    @prev         = prev
    @difficulty   = difficulty
    @nonce, @time = compute_hash_with_proof_of_work( difficulty )
  end

  def compute_hash_with_proof_of_work( difficulty='00' )
    nonce = 0
    time  = Time.now.to_i
    loop do
      hash = Digest::SHA256.hexdigest( "#{nonce}#{time}#{difficulty}#{prev}#{data}" )
      if hash.start_with?( difficulty )
        return [nonce,time]    ## bingo! proof of work if hash starts with leading zeros (00)
      else
        nonce += 1             ## keep trying (and trying and trying)
      end
    end # loop
  end # method compute_hash_with_proof_of_work

end # class Block



b0 = Block.new( 'Hello, Cryptos!', '0000000000000000000000000000000000000000000000000000000000000000' )
pp b0

b1 = Block.new( 'Hello, Cryptos! - Hello, Cryptos!', b0.hash )
pp b1

b2 = Block.new( 'Your Name Here', b1.hash )
pp b2
b3 = Block.new( 'Data Data Data Data', b2.hash )
pp b3


blockchain = [b0, b1, b2, b3]

pp blockchain      ## pretty print (pp) blockchain



## blockchain broken?

p b0.prev == '0000000000000000000000000000000000000000000000000000000000000000'
p b1.prev == b0.hash
p b2.prev == b1.hash
p b3.prev == b2.hash

# check time moving forward; timestamp always greater/bigger/younger
p b1.time       >= b0.time
p b2.time       >= b1.time
p b3.time       >= b2.time
p Time.now.to_i >= b3.time   ## back to the future (not yet) possible :-)

p b0.hash == Digest::SHA256.hexdigest( "#{b0.nonce}#{b0.time}#{b0.difficulty}#{b0.prev}#{b0.data}" )
p b1.hash == Digest::SHA256.hexdigest( "#{b1.nonce}#{b1.time}#{b1.difficulty}#{b1.prev}#{b1.data}" )
p b2.hash == Digest::SHA256.hexdigest( "#{b2.nonce}#{b2.time}#{b2.difficulty}#{b2.prev}#{b2.data}" )
p b3.hash == Digest::SHA256.hexdigest( "#{b3.nonce}#{b3.time}#{b3.difficulty}#{b3.prev}#{b3.data}" )

def sha256( data )
  Digest::SHA256.hexdigest( data )
end

p b0.hash == sha256( "#{b0.nonce}#{b0.time}#{b0.difficulty}#{b0.prev}#{b0.data}" )
p b1.hash == sha256( "#{b1.nonce}#{b1.time}#{b1.difficulty}#{b1.prev}#{b1.data}" )
p b2.hash == sha256( "#{b2.nonce}#{b2.time}#{b2.difficulty}#{b2.prev}#{b2.data}" )
p b3.hash == sha256( "#{b3.nonce}#{b3.time}#{b3.difficulty}#{b3.prev}#{b3.data}" )


p b0.hash.start_with?( b0.difficulty )    ## b0.difficulty == '0000'
p b1.hash.start_with?( b1.difficulty )    ## b1.difficulty == '0000'
p b2.hash.start_with?( b2.difficulty )    ## b2.difficulty == '0000'
p b3.hash.start_with?( b3.difficulty )    ## b3.difficulty == '0000'
