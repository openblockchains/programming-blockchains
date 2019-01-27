# Blockchain

Blockchain! Blockchain! Blockchain!

![](i/fake-dilbert-blockchain.png)

Let's link the (crypto) blocks together into a chain of blocks, that is, blockchain,
to revolutionize the world one block at a time.

Trivia Quiz: What's the unique id(entifier) of a block?

- (A) (Secure) Hash
- (B) Block Hash
- (C) Digital (Crypto) Digest

A: All of the above :-). (Secure) hash == block hash == digital (crypto) digest.

Thus, add the (secure) hash of the prev(ious) block to
the new block and the hash calculation e.g.:

```ruby
Digest::SHA256.hexdigest( "#{nonce}#{prev}#{data}" )
```

Bingo! Blockchain! Blockchain! Blockchain! All together now:


```ruby
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
```

Note: For the first block, that is, the genesis block,
there's no prev(ious) block. What (block) hash to use?
Let's follow the classic bitcoin convention and lets use all zeros
eg. `0000000000000000000000000000000000000000000000000000000000000000`.


Genesis. A new blockchain is born!

``` ruby
b0 = Block.new( 'Hello, Cryptos!', '0000000000000000000000000000000000000000000000000000000000000000' )
#=> #<Block:0x4d11ce0
#       @data="Hello, Cryptos!",
#       @hash="000047954e7d5877b6dea6915c48e84579b5c64fb58d5b6488863c241f1ce2af",
#       @nonce=24287,
#       @prev="0000000000000000000000000000000000000000000000000000000000000000">
```

Let's mine (build) some more blocks linked (chained) together with crypto hashes:

``` ruby
b1 = Block.new( 'Hello, Cryptos! - Hello, Cryptos!',
                '000047954e7d5877b6dea6915c48e84579b5c64fb58d5b6488863c241f1ce2af' )
# -or-
b1 = Block.new( 'Hello, Cryptos! - Hello, Cryptos!', b0.hash )
#=> #<Block:0x4dce620
#      @data="Hello, Cryptos! - Hello, Cryptos!",
#      @hash="00002acb41e00fb252b8fedeed7d4a629dafb28517bcf6235b90367ee6f63a7f",
#      @nonce=191453,
#      @prev="000047954e7d5877b6dea6915c48e84579b5c64fb58d5b6488863c241f1ce2af">

b2 = Block.new( 'Your Name Here', b1.hash )
#=> #<Block:0x4d9d798
#       @data="Your Name Here",
#       @hash="0000d85423bc8d3ccda0e83ddd6e7e9d6a30f393b73705409b481be57eeaad37",
#       @nonce=109213,
#       @prev="00002acb41e00fb252b8fedeed7d4a629dafb28517bcf6235b90367ee6f63a7f">

b3 = Block.new( 'Data Data Data Data', b2.hash )
#=> #<Block:0x46cfc80
#       @data="Data Data Data Data",
#       @hash="000000c652265dcf44f0b18911435100f4677bdc468f8f1dd85910d581b3542d",
#       @nonce=129257,
#       @prev="0000d85423bc8d3ccda0e83ddd6e7e9d6a30f393b73705409b481be57eeaad37">
```

Let's store all blocks together (in an array):

``` ruby
blockchain = [b0, b1, b2, b3]

pp blockchain      ## pretty print (pp) blockchain

#=> [#<Block:0x4d010a8
#        @data="Hello, Cryptos!",
#        @hash="000047954e7d5877b6dea6915c48e84579b5c64fb58d5b6488863c241f1ce2af",
#        @nonce=24287,
#        @prev="0000000000000000000000000000000000000000000000000000000000000000">,
#    #<Block:0x4685388
#        @data="Hello, Cryptos! - Hello, Cryptos!",
#        @hash="00002acb41e00fb252b8fedeed7d4a629dafb28517bcf6235b90367ee6f63a7f",
#        @nonce=191453,
#        @prev="000047954e7d5877b6dea6915c48e84579b5c64fb58d5b6488863c241f1ce2af">,
#    #<Block:0x4d6d120
#        @data="Your Name Here",
#        @hash="0000d85423bc8d3ccda0e83ddd6e7e9d6a30f393b73705409b481be57eeaad37",
#        @nonce=109213,
#        @prev="00002acb41e00fb252b8fedeed7d4a629dafb28517bcf6235b90367ee6f63a7f">,
#    #<Block:0x469ec30
#        @data="Data Data Data Data",
#        @hash="000000c652265dcf44f0b18911435100f4677bdc468f8f1dd85910d581b3542d",
#        @nonce=129257,
#        @prev="0000d85423bc8d3ccda0e83ddd6e7e9d6a30f393b73705409b481be57eeaad37">]
```

Note: If you want to change the data in block b1, for examples,
you have to change all the blocks on top (that is, b2 and b3) too and update their hashes too!
With every block added breaking the chain gets harder and harder and harder
(not to say practically impossible!).
That's the magic of the blockchain - it's (almost) unbreakable if you have many shared / cloned copies.
The data gets more secure with every block added (on top), ...

<!--
that's why the convention in classic bitcoin is to wait for six (6) "confirmations"
that is, blocks added on top, for
and to wait for one hundred (100) "confirmations" for
unlocking the mining rewards.
-->



## Blockchain Broken?

How do you know if anyone changed (broke) the (almost) unbreakable blockchain
and changed some data in blocks?
Let's run tests checking up on the chained / linked (crypto) hashes:

``` ruby
b0.prev == '0000000000000000000000000000000000000000000000000000000000000000'
#=> true
b1.prev == b0.hash
#=> true
b2.prev == b1.hash
#=> true
b3.prev == b2.hash
#=> true
```

All true, true, true, true. All in order? What if someone changes the data
but keeps the original (now fake non-matching) hash?
Let's run more tests checking up on the (crypto) hashes by recalculating
(using `nonce`+`prev`+`data`) right on the spot
plus checking up on the proof-of-work difficulty (hash must start with `0000`):


``` ruby
## shortcut convenience helper
def sha256( data )
  Digest::SHA256.hexdigest( data )
end

b0.hash == sha256( "#{b0.nonce}#{b0.prev}#{b0.data}" )
# => true
b1.hash == sha256( "#{b1.nonce}#{b1.prev}#{b1.data}" )
# => true
b2.hash == sha256( "#{b2.nonce}#{b2.prev}#{b2.data}" )
# => true
b3.hash == sha256( "#{b3.nonce}#{b3.prev}#{b3.data}" )
# => true

b0.hash.start_with?( '0000' )
# => true
b1.hash.start_with?( '0000' )
# => true
b2.hash.start_with?( '0000' )
# => true
b3.hash.start_with?( '0000' )
# => true
```

All true, true, true, true, true, true, true, true. All in order? Yes. The blockchain is (almost) unbreakable.


Let's try to break the unbreakable.
Let's change the block b1 from
`'Hello, Cryptos!'` to `'Hello, Koruptos!'`:

``` ruby
b1 = Block.new( 'Hello, Koruptos! - Hello, Koruptos!', b0.hash )
#=> #<Block:0x4daa9f8
#       @data="Hello, Koruptos! - Hello, Koruptos!",
#       @hash="00000c915e240a2b386fc86ef6170261a19292b9fdebebce049c621da1ab7e8f",
#       @nonce=27889,
#       @prev="000047954e7d5877b6dea6915c48e84579b5c64fb58d5b6488863c241f1ce2af">
```

Now if you check:

``` ruby
b0.prev == '0000000000000000000000000000000000000000000000000000000000000000'
#=> true
b1.prev == b0.hash
#=> true
b2.prev == b1.hash
#=> false
b3.prev == b2.hash
#=> true
```

Fail! False! No longer all true. The chain is now broken.
The chained / linked (crypto) hashes

- `b1.hash` => `00002acb41e00fb252b8fedeed7d4a629dafb28517bcf6235b90367ee6f63a7f`
- `b2.prev` => `00000c915e240a2b386fc86ef6170261a19292b9fdebebce049c621da1ab7e8f`

do no longer match.
The only way to get the chained / linked (crypto) hashes back in order
to true, true, true, true is to rebuild (remine) all blocks on top.
