require 'digest'
require 'pp'      ## pp = pretty print

class Block
  attr_reader :data
  attr_reader :hash

  def initialize(data)
    @data = data
    @hash = Digest::SHA256.hexdigest( data )
  end
end


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
