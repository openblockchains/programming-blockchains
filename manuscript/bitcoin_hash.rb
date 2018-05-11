require 'digest'
require 'pp'


p Time.at( 1231006505 ).utc
p Time.utc( 2009, 1, 3, 18, 15, 5 ).to_i



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



version    = 1
prev       = '0000000000000000000000000000000000000000000000000000000000000000'
merkleroot = '4a5e1e4baab89f3a32518a88c31bc87f618f76673e2cc77ab2127b7afdeda33b'
time       = 1231006505
bits       = '1d00ffff'
nonce      = 2083236893



header =
   int4( version       ) +
  hex32( prev          ) +
  hex32( merkleroot    ) +
   int4( time          ) +
   int4( bits.to_i(16) ) +
   int4( nonce         )

p header.size
p bin_to_hex( header )

d1 = Digest::SHA256.digest( header )
d2 = Digest::SHA256.digest( d1 )
p bin_to_hex32( d2 )



pp int4( version )
pp bin_to_hex( int4( version ))
pp "%08x" % version

pp hex32( merkleroot )
pp bin_to_hex( hex32( merkleroot ))
pp bin_to_hex32( hex32( merkleroot ))



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
p bin_to_hex32( d2 )
