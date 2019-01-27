# Timestamping

How can you make the blockchain even more secure?
Link it to the real world! Let's add a timestamp:

``` ruby
Time.now
# => 2018-03-17 14:12:01 +0100
```

or in Epoch time (that is, seconds since January 1st, 1970)


``` ruby
Time.now.to_i
# => 1521292321
```

Note: You can use `Time.at` to convert Epoch time back
to the standard "classic" format:

``` ruby
Time.at( 1521292321 )
# => 2018-03-17 14:12:01 +0100
```

Now the blockchain must always move forward,
that is, you can only add a new block if the timestamp is bigger / younger
than the previous block's timestamp.


Unbreakable. Unbreakable. Unbreakable. What else?

Let's add the proof-of-work difficulty (e.g. '00', '000', '0000' etc.)
to the hash to make the difficulty unbreakable / unchangeable too!

Last but not least let's drop the "pre-calculated" hash
attribute and let's always calculate the hash on demand e.g.:

``` ruby
def hash
  Digest::SHA256.hexdigest( "#{nonce}#{time}#{difficulty}#{prev}#{data}" )
end
```

Remember: Calculating the block's (crypto) hash is fast, fast, fast. What take's time depending
on the proof-of-work difficulty is finding the nonce, that is, the lucky number used once.


All together now. Resulting in:


``` ruby
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
```

Proof of the pudding. Let's build a new (more secure) blockchain
from scratch (zero). Genesis!

``` ruby
b0 = Block.new( 'Hello, Cryptos!', '0000000000000000000000000000000000000000000000000000000000000000' )
#=> #<Block:0x4d00700
#       @data="Hello, Cryptos!",
#       @difficulty="0000",
#       @nonce=215028,
#       @prev="0000000000000000000000000000000000000000000000000000000000000000",
#       @time=1521292321>
```

Let's mine (build) some more blocks linked (chained) together with crypto hashes:

``` ruby
b1 = Block.new( 'Hello, Cryptos! - Hello, Cryptos!', b0.hash )
#=> #<Block:0x4ed7940
#       @data="Hello, Cryptos! - Hello, Cryptos!",
#       @difficulty="0000",
#       @nonce=3264,
#       @prev="0000071b9c71675db90b0bb819236d76be97ac75f9f379d078456495133b18c6",
#       @time=1521292325>

b2 = Block.new( 'Your Name Here', b1.hash )
#=> #<Block:0x2f297e8
#       @data="Your Name Here",
#       @difficulty="0000",
#       @nonce=81552,
#       @prev="0000a6f83a7883891afea2536891df228a1c527add36c1cc38999e566eeed6a7",
#       @time=1521292325>

b3 = Block.new( 'Data Data Data Data', b2.hash )
#=> #<Block:0x4dbd9d0
#       @data="Data Data Data Data",
#       @difficulty="0000",
#       @nonce=43010,
#       @prev="00009b581870a4e0792f84786e1d089e32f2820459cd878298c6b62974afd0bc",
#       @time=1521292326>
```


Blockchain broken?
Let's run all the tests checking up on the chained / linked (crypto) hashes,
timestamps, proof-of-work difficulty and more:

``` ruby
## shortcut convenience helper
def sha256( data )
  Digest::SHA256.hexdigest( data )
end

b0.hash == sha256( "#{b0.nonce}#{b0.time}#{b0.difficulty}#{b0.prev}#{b0.data}" )
# => true
b1.hash == sha256( "#{b1.nonce}#{b1.time}#{b1.difficulty}#{b1.prev}#{b1.data}" )
# => true
b2.hash == sha256( "#{b2.nonce}#{b2.time}#{b2.difficulty}#{b2.prev}#{b2.data}" )
# => true
b3.hash == sha256( "#{b3.nonce}#{b3.time}#{b3.difficulty}#{b3.prev}#{b3.data}" )
# => true

# check proof-of-work difficulty (e.g. '0000')
b0.hash.start_with?( b0.difficulty )
# => true
b1.hash.start_with?( b1.difficulty )
# => true
b2.hash.start_with?( b2.difficulty )
# => true
b3.hash.start_with?( b3.difficulty )
# => true

## check chained / linked hashes
b0.prev == '0000000000000000000000000000000000000000000000000000000000000000'
#=> true
b1.prev == b0.hash
#=> true
b2.prev == b1.hash
#=> true
b3.prev == b2.hash
#=> true

# check time moving forward; timestamp always greater/bigger/younger
b1.time > b0.time
#=> true
b2.time > b1.time
#=> true
b3.time > b2.time
#=> true
Time.now.to_i > b3.time   ## back to the future (not yet) possible :-)
#=> true
```

All true, true, true, true, true, true, true, true.
All in order? Yes. The blockchain is (almost) unbreakable.
