# Bitcoin, Bitcoin, Bitcoin

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
