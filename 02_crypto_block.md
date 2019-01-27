# (Crypto) Block

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
