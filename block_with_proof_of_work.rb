require 'digest'
require 'pp'      ## pp = pretty print


class Block
  attr_reader :data
  attr_reader :hash
  attr_reader :nonce  # number used once - lucky (mining) lottery number

  def initialize(data)
    @data          = data
    @nonce, @hash  = compute_hash_with_proof_of_work
  end

  def compute_hash_with_proof_of_work( difficulty='00' )
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

end # class Block



pp Block.new( 'Hello, Cryptos!' )

pp Block.new( 'Hello, Cryptos! - Hello, Cryptos! - Hello, Cryptos!' )

pp Block.new( 'Your Name Here' )

pp Block.new( 'Data Data Data Data' )

pp Block.new( <<TXT )
  Data Data Data Data Data Data
  Data Data Data Data Data Data
  Data Data Data Data Data Data
  Data Data Data Data Data Data
  Data Data Data Data Data Data
TXT


p Digest::SHA256.hexdigest( "0Hello, Cryptos!" )
p Digest::SHA256.hexdigest( "1Hello, Cryptos!" )
p Digest::SHA256.hexdigest( "2Hello, Cryptos!" )

p Digest::SHA256.hexdigest( "143Hello, Cryptos!" )


p Digest::SHA256.hexdigest( '26762Hello, Cryptos!' )
p Digest::SHA256.hexdigest( '68419Hello, Cryptos! - Hello, Cryptos! - Hello, Cryptos!' )
p Digest::SHA256.hexdigest( '23416Your Name Here' )
p Digest::SHA256.hexdigest( '15353Data Data Data Data' )
