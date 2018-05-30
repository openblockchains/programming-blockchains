---
title: Programming Blockchains Step-by-Step
---


Let's build blockchains from scratch (zero) step by step.



## (Crypto) Hash

Let's start with crypto hashes

Classic Bitcoin uses the SHA256 hash algorithm. Let's try

```ruby
require 'digest'

Digest::SHA256.hexdigest( 'Hello, Cryptos!' )
```

resulting in

``` ruby
#=> "33eedea60b0662c66c289ceba71863a864cf84b00e10002ca1069bf58f9362d5"
```

Try some more

``` ruby
Digest::SHA256.hexdigest( 'Hello, Cryptos! - Hello, Cryptos! - Hello, Cryptos!' )
#=> "c4b5e2b9685062ecca5d0f6f6ba605b3f99eafed3a3729d2ae1ccaa2b440b1cc"
Digest::SHA256.hexdigest( 'Your Name Here' )
#=> "39459289c09c33a7b516bef926c1873c6ecd2e6db09218b065d7465b6736f801"
Digest::SHA256.hexdigest( 'Data Data Data Data' )
#=> "a7bbfc531b2ecf641b9abcd7ad8e50267e1c873e5a396d1919f504973090565a"
```


Note: The resulting hash is always 256-bit in size
or 64 hex(adecimal) chars (0-9,a-f) in length
even if the input is less than 256-bit or much bigger than 256-bit:


``` ruby
Digest::SHA256.hexdigest( <<TXT )
  Data Data Data Data Data Data
  Data Data Data Data Data Data
  Data Data Data Data Data Data
  Data Data Data Data Data Data
  Data Data Data Data Data Data
TXT
#=> "c51023e2c874b6cf46cb0acef183ee1c05f14746636352d1b2cb9fc6aa5c3cee"

## use String#length

Digest::SHA256.hexdigest( 'Hello, Cryptos!' ).length
# => 64
Digest::SHA256.hexdigest( 'Hello, Cryptos! - Hello, Cryptos! - Hello, Cryptos!' ).length
# => 64
```

Note: 1 hex char is 4-bits, 2 hex chars are 4x2=8 bits
and 64 hex chars are 4x64=256 bits.

Hexa(decimal) chart:

|binary|hex (2^4=16)|decimal|binary|hex (2^4=16)|decimal|
|------|------------|-------|------|------------|-------|
| 0000 | **0**      | 0     | 1000 | **8**      | 8     |
| 0001 | **1**      | 1     | 1001 | **9**      | 9     |
| 0010 | **2**      | 2     | 1010 | **a**      | 10    |
| 0011 | **3**      | 3     | 1011 | **b**      | 11    |
| 0100 | **4**      | 4     | 1100 | **c**      | 12    |
| 0101 | **5**      | 5     | 1101 | **d**      | 13    |
| 0110 | **6**      | 6     | 1110 | **e**      | 14    |
| 0111 | **7**      | 7     | 1111 | **f**      | 15    |



Let's convert from hex (base 16) to decimal (integer) number (base 10)

``` ruby
hex = Digest::SHA256.hexdigest( 'Hello, Cryptos!' )
#=> "33eedea60b0662c66c289ceba71863a864cf84b00e10002ca1069bf58f9362d5"

hex.to_i( 16 )
#=> 23490001543365037720284007500157053051505610714786813679598750288695740555989
```

and convert to 256-bits (32-bytes) binary number (base 2) as a string:

``` ruby
hex.to_i( 16 ).to_s( 2 )
# => "0011 0011 1110 1110 1101 1110 1010 0110 0000 1011 0000 0110 0110 0010 1100 0110
#     0110 1100 0010 1000 1001 1100 1110 1011 1010 0111 0001 1000 0110 0011 1010 1000
#     0110 0100 1100 1111 1000 0100 1011 0000 0000 1110 0001 0000 0000 0000 0010 1100
#     1010 0001 0000 0110 1001 1011 1111 0101 1000 1111 1001 0011 0110 0010 1101 0101"
```


Trivia Quiz: What's SHA256?

- (A) Still Hacking Anyway
- (B) Secure Hash Algorithm
- (C) Sweet Home Austria
- (D) Super High Aperture

B: SHA256 == Secure Hash Algorithms 256 Bits

SHA256 is a (secure) hashing algorithm designed by the National Security Agency (NSA)
of the United States of America (USA).

Find out more @ [Secure Hash Algorithms (SHA) @ Wikipedia](https://en.wikipedia.org/wiki/Secure_Hash_Algorithms).


A (secure) hash is also known as:

- Digital (Crypto) Fingerprint == (Secure) Hash
- Digital (Crypto) Digest      == (Secure) Hash
- Digital (Crypto) Checksum    == (Secure) Hash




## (Crypto) Block

Let's build blocks (secured) with crypto hashes.
First let's define a block class:


``` ruby
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
```

And let's mine (build) some blocks with crypto hashes:


``` ruby
pp Block.new( 'Hello, Cryptos!' )
#=> #<Block:0x1ef9a68
#       @data="Hello, Cryptos!",
#       @hash="33eedea60b0662c66c289ceba71863a864cf84b00e10002ca1069bf58f9362d5">

pp Block.new( 'Hello, Cryptos! - Hello, Cryptos! - Hello, Cryptos!' )
#=> <Block:0x1eebdd0
#      @data="Hello, Cryptos! - Hello, Cryptos! - Hello, Cryptos!",
#      @hash="c4b5e2b9685062ecca5d0f6f6ba605b3f99eafed3a3729d2ae1ccaa2b440b1cc">

pp Block.new( 'Your Name Here' )
#=> #<Block:0x1eeac78
#       @data="Your Name Here",
#       @hash="39459289c09c33a7b516bef926c1873c6ecd2e6db09218b065d7465b6736f801">

pp Block.new( 'Data Data Data Data' )
#=> <Block:0x1ee9b98
#      @data="Data Data Data Data",
#      @hash="a7bbfc531b2ecf641b9abcd7ad8e50267e1c873e5a396d1919f504973090565a">
```

Note: All the hashes (checksums/digests/fingerprints)
are the same as above!
Same input e.g. `'Hello, Cryptos!'`,
same hash e.g. `33eedea60b0662c66c289ceba71863a864cf84b00e10002ca1069bf58f9362d5`,
same length e.g. 64 hex chars!

And the biggie:

``` ruby
pp Block.new( <<TXT )
  Data Data Data Data Data Data
  Data Data Data Data Data Data
  Data Data Data Data Data Data
  Data Data Data Data Data Data
  Data Data Data Data Data Data
TXT

# => #<Block:0x1e489a8
#       @data="  Data Data Data Data Data Data\n
#                Data Data Data Data Data Data\n
#                Data Data Data Data Data Data\n
#                Data Data Data Data Data Data\n
#                Data Data Data Data Data Data\n",
#       @hash="c51023e2c874b6cf46cb0acef183ee1c05f14746636352d1b2cb9fc6aa5c3cee">
```



## (Crypto) Block with Proof-of-Work

Let's add a proof-of-work to the block and hash.
and let's start mining to find the nonce (=Number used ONCE)
and let's start with the "hard-coded" difficulty of two leading zeros '00'.

In classic bitcoin you have to compute a hash
that starts with leading zeros (`00`). The more leading zeros the harder (more difficult) to compute. Let's keep it easy to compute and let's start with two leading zeros (`00`), that is, 16^2 = 256 possibilities (^1,2).
Three leading zeros (`000`) would be 16^3 = 4 096 possibilities
and four zeros (`0000`) would be 16^4 = 65 536 and so on.

(1): 16 possibilities because it's a hex or hexadecimal or base 16 number, that is, `0` `1` `2` `3` `4` `5` `6` `7` `8` `9` `a` (10) `b` (11) `c` (12) `d` (13) `e` (14) `f` (15).

(2): A random secure hash algorithm needs on average 256 tries (might be lets say 305 tries, for example, because it's NOT a perfect statistic distribution of possibilities).


``` ruby
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
```

And let's mine (build) some blocks with crypto hashes
with a "hard-coded" difficulty of two leading zeros '00':


``` ruby
pp Block.new( 'Hello, Cryptos!' )
#=> #<Block:0x1d84b50
#       @data="Hello, Cryptos!",
#       @hash="00ecb8b247998f9ddd15d2a5693777ee0041d138fa3bc5c1f6ccc12ec1cfece4",
#       @nonce=143>

pp Block.new( 'Hello, Cryptos! - Hello, Cryptos! - Hello, Cryptos!' )
#=> #<Block:0x1d67f18
#       @data="Hello, Cryptos! - Hello, Cryptos! - Hello, Cryptos!",
#       @hash="0014406a868d202e2c6c3896af997e189daafc9df1878f9824cba2050fda199f",
#       @nonce=59>

pp Block.new( 'Your Name Here' )
#=> #<Block:0x1d64270
#       @data="Your Name Here",
#       @hash="0012c3a90e58c9569ef0c036e6220c86c7c253ac94c0eb0064bf98df59acdfad",
#       @nonce=57>

pp Block.new( 'Data Data Data Data' )
#=> #<Block:0x139b828
#       @data="Data Data Data Data",
#       @hash="00e2da510b97434713d63234f3ba2d816c8d52f29f9ffd267423c39d9ced7a70",
#       @nonce=73>
```

See the difference? Now all hashes start with '00' e.g.

| Block | Hash with Proof-of-Work |
|-------|-------------------------|
| #1    | `00ecb8b247998f9ddd15d2a5693777ee0041d138fa3bc5c1f6ccc12ec1cfece4` |
| #2    | `0014406a868d202e2c6c3896af997e189daafc9df1878f9824cba2050fda199f` |
| #3    | `0012c3a90e58c9569ef0c036e6220c86c7c253ac94c0eb0064bf98df59acdfad` |
| #4    | `00e2da510b97434713d63234f3ba2d816c8d52f29f9ffd267423c39d9ced7a70` |


That's the magic of the proof-of-work.
You have done the work, that is,
found the lucky lottery number used once (nonce)
and proof is the hash with the matching difficulty, that is,
the two leading zeros `00`.

In the first block the `compute_hash_with_proof_of_work`
tried 143 nonces until finding the matching lucky number.
The stat(istic)s for all blocks are:

| Block | Loops / Number of Hash calculations |
|-------|-------------------------------------|
| #1    | 143                                 |
| #2    | 59                                  |
| #3    | 57                                  |
| #4    | 73                                  |

The lucky nonce for block #1 is 143:

Try:

``` ruby
Digest::SHA256.hexdigest( '0Hello, Cryptos!' )   # keep trying...
# => "8954dec596f0baa0cb6b8cc9f5837037d4380e28338ccccdf5f00658010caf07"
Digest::SHA256.hexdigest( '1Hello, Cryptos!' )   # keep trying...
# => "831c988d0745d1f02cf790c3b3d9c9f610ddb7d36d5b96c7b3413ccd1b6f46e1"
Digest::SHA256.hexdigest( '2Hello, Cryptos!' )   # keep trying...
# => "ac6ccb11092f867dc5f10daaebcd7938f90d1627a7e277b940cdd2e4881ea712"
# ...
```

Now try:

``` ruby
Digest::SHA256.hexdigest( '143Hello, Cryptos!' )   # bingo!!!
# => "00ecb8b247998f9ddd15d2a5693777ee0041d138fa3bc5c1f6ccc12ec1cfece4"
```

Let's try a difficulty of four leading zeros '0000'.

Note: One hex char is 4-bits, thus, '0' in hex (base16)
is '0000' in binary (base2) and, thus, '00' in hex (base16)
is 2x4=8 zeros in binary (base2) e.g. '0000 0000'
and, thus, '0000' in hex (base16) is 4x4=16 zeros in binary (base)
e.g. '0000 0000 0000 0000'


Change the "hard-coded" difficulty from `00` to `0000` e.g.

``` ruby
def compute_hash_with_proof_of_work( difficulty='0000' )
...
end
```

and rerun or let's mine blocks again:

``` ruby
pp Block.new( 'Hello, Cryptos!' )
#=> #<Block:0x1ef4b60
#       @data="Hello, Cryptos!",
#       @hash="0000a1ee5cb18c8d9fff5262b6dcb1bc95d54a331713e247f699f158f2022143",
#       @nonce=26762>

pp Block.new( 'Hello, Cryptos! - Hello, Cryptos! - Hello, Cryptos!' )
#=> #<Block:0x1f4c160
#       @data="Hello, Cryptos! - Hello, Cryptos! - Hello, Cryptos!",
#       @hash="0000b27eeebe56b2daafeb935454d0e3f423fc7f5ac7a99e952f9b80475ef6c3",
#       @nonce=68419>

pp Block.new( 'Your Name Here' )
#=> #<Block:0x1ee8800
#       @data="Your Name Here",
#       @hash="00000e59a4a7fb35d0d03def6ce31f503c208e6c291dcc9a217a7278ad1b95ce",
#       @nonce=23416>

pp Block.new( 'Data Data Data Data' )
# => #<Block:0x1f7a960
#        @data="Data Data Data Data",
#        @hash="00000e3cff496c5afc18645dba31ae9ba5c6077e5a5d980d8512e4581e7d61ec",
#        @nonce=15353>
```

See the difference? Now all hashes start with '0000' e.g.

| Block | Hash with Proof-of-Work |
|-------|-------------------------|
| #1    | `0000a1ee5cb18c8d9fff5262b6dcb1bc95d54a331713e247f699f158f2022143` |
| #2    | `0000b27eeebe56b2daafeb935454d0e3f423fc7f5ac7a99e952f9b80475ef6c3` |
| #3    | `00000e59a4a7fb35d0d03def6ce31f503c208e6c291dcc9a217a7278ad1b95ce` |
| #4    | `00000e3cff496c5afc18645dba31ae9ba5c6077e5a5d980d8512e4581e7d61ec` |


The nonce hash calculation stat(istic)s for all blocks are:

| Block | Loops / Number of Hash calculations |
|-------|-------------------------------------|
| #1    | 26 762                              |
| #2    | 68 419                              |
| #3    | 23 416                              |
| #4    | 15 353                              |

In the first block the `compute_hash_with_proof_of_work`
now tried 26 762 nonces (compare 143 nonces with difficulty '00')
until finding the matching lucky number.


Now try it with the latest difficulty in bitcoin, that is, with 24 leading zeros -
just kidding. You will need trillions of mega zillions of hash calculations
and all minining computers in the world will need all together about ten (10) minutes
to find the lucky number used once (nonce)
and mine the next block.


Let's retry the '0000' difficulty hash calculations "by hand":

``` ruby
Digest::SHA256.hexdigest( '26762Hello, Cryptos!' )
#=> "0000a1ee5cb18c8d9fff5262b6dcb1bc95d54a331713e247f699f158f2022143"
Digest::SHA256.hexdigest( '68419Hello, Cryptos! - Hello, Cryptos! - Hello, Cryptos!' )
#=> "0000b27eeebe56b2daafeb935454d0e3f423fc7f5ac7a99e952f9b80475ef6c3"
Digest::SHA256.hexdigest( '23416Your Name Here' )
#=> "00000e59a4a7fb35d0d03def6ce31f503c208e6c291dcc9a217a7278ad1b95ce"
Digest::SHA256.hexdigest( '15353Data Data Data Data' )
#=> "00000e3cff496c5afc18645dba31ae9ba5c6077e5a5d980d8512e4581e7d61ec"
```




## Blockchain

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



## Timestamping

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




## Mining, Mining, Mining

What's your hash rate? Let's find out.
Let's use a "stand-alone" version of the by now "classic" `compute_hash_with_proof_of_work`
function:

``` ruby
require 'digest'

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
```

Let's try (run) benchmarks for the difficulty from `0` (4 bits)
to `0000000` (28 bits).
Remember: `0` in hex (base16, 2^4 bits) equals `0000` in binary (base2),
thus, `0000000` in hex (base16) equals `0` x 4 x 7 = 28 zero bits
in binary (base2).  Example:

``` ruby
(1..7).each do |factor|
   difficulty = '0' * factor
   puts "difficulty: #{difficulty} (#{difficulty.length*4} bits)"
end

# => difficulty: 0 (4 bits)
#    difficulty: 00 (8 bits)
#    difficulty: 000 (12 bits)
#    difficulty: 0000 (16 bits)
#    difficulty: 00000 (20 bits)
#    difficulty: 000000 (24 bits)
#    difficulty: 0000000 (28 bits)
```

Let's add the hash proof-of-work hash computing
machinery and re(run):

``` ruby
(1..7).each do |factor|
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
```

Resulting on a "low-end" home computer:

```
Difficulty: 0 (4 bits)
Starting search...
Elapsed Time: 0.0156 seconds, Hashes Calculated: 56
Hash Rate: 3 588 hashes per second

Difficulty: 00 (8 bits)
Starting search...
Elapsed Time: 0.0000 seconds, Hashes Calculated: 143
Hash Rate: Infinity ;-)

Difficulty: 000 (12 bits)
Starting search...
Elapsed Time: 0.0313 seconds, Hashes Calculated: 3 834
Hash Rate: 122 684 hashes per second

Difficulty: 0000 (16 bits)
Starting search...
Elapsed Time: 0.2656 seconds, Hashes Calculated: 26 762
Hash Rate: 100 753 hashes per second

Difficulty: 00000 (20 bits)
Starting search...
Elapsed Time: 1.2031 seconds, Hashes Calculated: 118 592
Hash Rate: 98 569 hashes per second

Difficulty: 000000 (24 bits)
Starting search...
Elapsed Time: 220.5767 seconds, Hashes Calculated: 21 554 046
Hash Rate: 97 716 hashes per second

Difficulty: 0000000 (28 bits)
Starting search...
```

To sum up the hash rate is about 100 000 hashes per second
on a "low-end" home computer. What's your hash rate?
Run the benchmark on your machinery!

The search for the 28 bits difficulty proof-of-work hash
is still running... expected to find the lucky number in the next hours...  


Trivia Quiz: What's the Hash Rate of the Bitcoin Classic Network?

A: About 25 million trillions of hashes per second (in March 2018)

Estimated number of tera hashes per second (trillions of hashes per second)
the Bitcoin network is performing.

![](i/bitcoin-hashrate.png)

(Source: [blockchain.info](https://blockchain.info/charts/hash-rate))




## Bitcoin, Bitcoin, Bitcoin

Let's calculate the classic bitcoin (crypto) block hash from scratch (zero).
Let's start with the genesis block, that is block #0
with the unique block hash id `000000000019d6689c085ae165831e934ff763ae46a2a6c172b3f1b60a8ce26f`.

Note: You can search and browse bitcoin blocks using (online)
block explorers. Example:

- [blockchain.info/block/000000000019d6689c085ae165831e934ff763ae46a2a6c172b3f1b60a8ce26f](https://blockchain.info/block/000000000019d6689c085ae165831e934ff763ae46a2a6c172b3f1b60a8ce26f)
- [blockexplorer.com/block/000000000019d6689c085ae165831e934ff763ae46a2a6c172b3f1b60a8ce26f](https://blockexplorer.com/block/000000000019d6689c085ae165831e934ff763ae46a2a6c172b3f1b60a8ce26f)
- and others.


The classic bitcoin (crypto) block hash gets calculated from
the 80-byte block header:

| Field      | Size (Bytes) | Comments           |
|------------|--------------|--------------------|
| version    | 4  byte      | Block version number  |
| prev       | 32 byte      | 256-bit hash of the previous block header |
| merkleroot | 32 byte      |	256-bit hash of all transactions in the block |
| time	     | 4 bytes      | Current timestamp as seconds since 1970-01-01 00:00 |
| bits       | 4 bytes      | Current difficulty target in compact binary format |
| nonce      | 4 bytes      | 32-bit number of the (mined) lucky lottery number used once |

Note: 32 byte x 8 bit = 256 bit


Using the data for the genesis block the setup is:

``` ruby
version    = 1
prev       = '0000000000000000000000000000000000000000000000000000000000000000'
merkleroot = '4a5e1e4baab89f3a32518a88c31bc87f618f76673e2cc77ab2127b7afdeda33b'
time       = 1231006505
bits       = '1d00ffff'
nonce      = 2083236893
```

Remember: To convert from Epoch time (seconds since January 1st, 1970)
to classic time use:

``` ruby
Time.at( 1231006505 ).utc
#=> "2009-01-03 18:15:05"
```

Yes, the bitcoin classic started
on January 3rd, 2009 at 18h 15m 5s (2009-01-03 18:15:05).
Or in the other direction use:

``` ruby
Time.utc( 2009, 1, 3, 18, 15, 5 ).to_i
#=> 1231006505
```

What's UTC? Coordinated Universal Time is the "standard" world time.
Note: UTC does NOT observe daylight saving time.


**Binary Bytes - Little End(ian) vs Big End(ian)**

In theory calculating the block hash is as easy as:

``` ruby
## pseudo-code
header = "..."           # 80 bytes (binary)
d1 = sha256( header )
d2 = sha256( d1 )
d2.to_s                  # convert 32-byte (256-bit) binary to hex string
#=> "000000000019d6689c085ae165831e934ff763ae46a2a6c172b3f1b60a8ce26f"
```

Note: Classic bitcoin uses a double hash, that is,
for even higher security the hash gets hashed twice with the SHA256 algorithm
e.g. `sha256(sha256(header))`.

In practice let's deal with the different byte order conversions
from big endian (most significant bit first)
to little endian (least significant bit first) and back again.

Tip: Read more about [Endianness @ Wikipedia](https://en.wikipedia.org/wiki/Endianness).


Let's put together the (binary) 80-byte header using the
`int4` and `hex32` big-endian to little-endian byte order (to binary bytes)
conversion helpers:

``` ruby
header =
   int4( version       ) +
  hex32( prev          ) +
  hex32( merkleroot    ) +
   int4( time          ) +
   int4( bits.to_i(16) ) +
   int4( nonce         )

header.size
#=> 80

bin_to_hex( header )
# => "01000000" +
#    "0000000000000000000000000000000000000000000000000000000000000000" +
#    "3ba3edfd7a7b12b27ac72c3e67768f617fc81bc3888a51323a9fb8aa4b1e5e4a" +
#    "29ab5f49" +
#    "ffff001d" +
#    "1dac2b7c"
```

And run the hash calculations:

``` ruby
d1 = Digest::SHA256.digest( header )
d2 = Digest::SHA256.digest( d1 )
bin_to_hex32( d2 )
#=> '000000000019d6689c085ae165831e934ff763ae46a2a6c172b3f1b60a8ce26f'
```

Bingo! The resulting block hash is
`000000000019d6689c085ae165831e934ff763ae46a2a6c172b3f1b60a8ce26f`.


Let's backtrack and add the missing
binary conversion helpers, that is, `int4`, `hex32`, `bin_to_hex32` and `bin_to_hex`.


``` ruby
def int4( num )   ##  integer 4 byte(32bit) to binary (little endian)
  [num].pack( 'V' )
end

def hex32( hex )   ## hex string 32 byte(256bit) / 64 hex chars to binary
  [hex].pack( 'H*' ).reverse     ## change byte order (w/ reverse)
end

def bin_to_hex32( bytes )
  bytes.reverse.unpack( 'H*' )[0]   ## note: change byte order (w/ reverse)
end

def bin_to_hex( bytes )
  bytes.unpack( 'H*' )[0]
end
```


To convert integers (4 bytes / 32 bit) to binary bytes (in little endian)
use:

``` ruby
int4( version )
#=> "\x01\x00\x00\x00"
bin_to_hex( int4( version ))
#=> "01000000"
```
compare to "classic" hex string (in big endian):

``` ruby
pp "%08x" % version  
#=> "00000001"
```

What's better? Big-endian `00000001` or little-endian `01000000`?
What's better? Ruby or Python? Red or Blue? Bitshilling or Bitcoin?

Let's celebrate that there's more than one way to do it :-). Onwards.

To convert a hex string (32 byte / 256 bit / 64 hex chars) to binary
bytes (in little endian) use:

``` ruby
hex32( merkleroot )
#=> ";\xA3\xED\xFDz{\x12\xB2z\xC7,>gv\x8Fa\x7F\xC8\e\xC3\x88\x8A..."
bin_to_hex( hex32( merkleroot ))
#=> "3ba3edfd7a7b12b27ac72c3e67768f617fc81bc3888a51323a9fb8aa4b1e5e4a"
```

and to convert back from binary bytes (in little endian)
to a hex string use:

``` ruby
bin_to_hex32( hex32( merkleroot ))   # to little-endian and binary and back again
#=> "4a5e1e4baab89f3a32518a88c31bc87f618f76673e2cc77ab2127b7afdeda33b"
```

What's better? Big-endian `4a5e1e4baab89f3a32518a88c31bc87f618f76673e2cc77ab2127b7afdeda33b`
or little-endian `3ba3edfd7a7b12b27ac72c3e67768f617fc81bc3888a51323a9fb8aa4b1e5e4a`?


What's that `pack`/`unpack` magic?
See the ruby documentation
for `Array#pack` and `String#unpack`
for the binary data packing and unpacking machinery

To sum up all together now. Let's use the
Block #125552 used as a sample in the
[Bitcoin Block hashing algorithm](https://en.bitcoin.it/wiki/Block_hashing_algorithm)
wiki page:

``` ruby
version    =  1
prev       = '00000000000008a3a41b85b8b29ad444def299fee21793cd8b9e567eab02cd81'
merkleroot = '2b12fcf1b09288fcaff797d71e950e71ae42b91e8bdb2304758dfcffc2b620e3'
time       =  1305998791     ## 2011-05-21 17:26:31
bits       = '1a44b9f2'
nonce      =  2504433986

header =  int4( version       ) +
         hex32( prev          ) +
         hex32( merkleroot    ) +
          int4( time          ) +
          int4( bits.to_i(16) ) +
          int4( nonce         )

d1 = Digest::SHA256.digest( header )
d2 = Digest::SHA256.digest( d1 )
bin_to_hex32( d2 )
#=> "00000000000000001e8d6829a8a21adc5d38d0a473b144b6765798e61f98bd1d"
```


Bonus. For easy (re)use let's package up the bitcoin block header code into a class:

``` ruby
require 'digest'

module Bitcoin
  class Header
    attr_reader :version
    attr_reader :prev
    attr_reader :merkleroot
    attr_reader :time
    attr_reader :bits
    attr_reader :nonce

    def initialize( version, prev, merkleroot, time, bits, nonce )
       @version    = version
       @prev       = prev
       @merkleroot = merkleroot
       @time       = time
       @bits       = bits
       @nonce      = nonce
    end

    ## lets add a convenience c'tor helper
    def self.from_hash( h )
      new( h[:version],
           h[:prev],
           h[:merkleroot],
           h[:time],
           h[:bits],
           h[:nonce] )
    end

    def to_bin
       i4( version )       +
      h32( prev )          +
      h32( merkleroot )    +
       i4( time )          +
       i4( bits.to_i(16) ) +
       i4( nonce )
    end

    def hash
      bytes = sha256(sha256( to_bin ))
      bin_to_h32( bytes )
    end

    def sha256( bytes )
       Digest::SHA256.digest( bytes )
    end

    ## binary pack/unpack conversion helpers
    def i4( num )   ##  integer (4 byte / 32bit) to binary (in little endian)
      [num].pack( 'V' )
    end

    def h32( hex )   ## hex string (32 byte / 256 bit / 64 hex chars) to binary
      [hex].pack( 'H*' ).reverse     ## change byte order (w/ reverse)
    end

    def bin_to_h32( bytes )
      bytes.reverse.unpack( 'H*' )[0]   ## note: change byte order (w/ reverse)
    end
  end # class Header
end # module Bitcoin
```

and let's test drive it with the genesis block #0 and block #125552:

``` ruby
b0 =
Bitcoin::Header.from_hash(
  version:     1,
  prev:       '0000000000000000000000000000000000000000000000000000000000000000',
  merkleroot: '4a5e1e4baab89f3a32518a88c31bc87f618f76673e2cc77ab2127b7afdeda33b',
  time:        1231006505,
  bits:       '1d00ffff',
  nonce:       2083236893 )

b0.hash
#=> "000000000019d6689c085ae165831e934ff763ae46a2a6c172b3f1b60a8ce26f"

b125552 =
Bitcoin::Header.from_hash(
  version:     1,
  prev:       '00000000000008a3a41b85b8b29ad444def299fee21793cd8b9e567eab02cd81',
  merkleroot: '2b12fcf1b09288fcaff797d71e950e71ae42b91e8bdb2304758dfcffc2b620e3',
  time:        1305998791,
  bits:       '1a44b9f2',
  nonce:       2504433986 )

b125552.hash
#=> "00000000000000001e8d6829a8a21adc5d38d0a473b144b6765798e61f98bd1d"
```





## (Crypto) Block with Transactions (Tx)

To be continued.








## References / Links

- [Gem Series ++ Programming Cryptocurrencies and Blockchains in Ruby](http://yukimotopress.github.io/blockchains)
@ [Yuki & Moto Press Bookshelf](http://yukimotopress.github.io), Free (Online) Booklet
- [Awesome Blockchains](https://github.com/openblockchains/awesome-blockchains) @ [Open Bockchains](https://github.com/openblockchains)
- [Awesome Crypto](https://github.com/planetruby/awesome-crypto) @ [Planet Ruby](https://github.com/planetruby)



## Questions? Comments?

Send them to the [ruby-talk mailing list](https://www.ruby-lang.org/en/community/mailing-lists/)
or the [(online) ruby-talk discourse mirror](https://rubytalk.org)
or post them on the [ruby reddit](https://www.reddit.com/r/ruby). Thanks.
