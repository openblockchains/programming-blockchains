require 'digest'
require 'pp'      ## pp = pretty print


class Block
  attr_reader :data
  attr_reader :prev   # prev(ious) (block) hash
  attr_reader :hash
  attr_reader :nonce  # number used once - lucky (mining) lottery number

  def initialize(data, prev)
    @data          = data
    @prev          = prev
    @nonce, @hash  = compute_hash_with_proof_of_work
  end

  def compute_hash_with_proof_of_work( difficulty='0000' )
    nonce = 0
    loop do
      hash = Digest::SHA256.hexdigest( "#{nonce}#{prev}#{data}" )
      if hash.start_with?( difficulty )
        return [nonce,hash]    ## bingo! proof of work if hash starts with leading zeros (00)
      else
        nonce += 1             ## keep trying (and trying and trying)
      end
    end # loop
  end # method compute_hash_with_proof_of_work

end # class Block


b0 = Block.new( 'Hello, Cryptos!', '0000000000000000000000000000000000000000000000000000000000000000' )
pp b0

b1 = Block.new( 'Hello, Cryptos! - Hello, Cryptos!', '000047954e7d5877b6dea6915c48e84579b5c64fb58d5b6488863c241f1ce2af' )
pp b1
# -or-
b1 = Block.new( 'Hello, Cryptos! - Hello, Cryptos!', b0.hash )
pp b1

b2 = Block.new( 'Your Name Here', b1.hash )
pp b2
b3 = Block.new( 'Data Data Data Data', b2.hash )
pp b3


blockchain = [b0, b1, b2, b3]

pp blockchain      ## pretty print (pp) blockchain
