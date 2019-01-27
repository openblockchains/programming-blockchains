require 'digest'
require 'pp'


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



## test

pp b0 =
Bitcoin::Header.from_hash(
  version:     1,
  prev:       '0000000000000000000000000000000000000000000000000000000000000000',
  merkleroot: '4a5e1e4baab89f3a32518a88c31bc87f618f76673e2cc77ab2127b7afdeda33b',
  time:        1231006505,
  bits:       '1d00ffff',
  nonce:       2083236893 )

pp b0.hash

pp b125552 =
Bitcoin::Header.from_hash(
  version:     1,
  prev:       '00000000000008a3a41b85b8b29ad444def299fee21793cd8b9e567eab02cd81',
  merkleroot: '2b12fcf1b09288fcaff797d71e950e71ae42b91e8bdb2304758dfcffc2b620e3',
  time:        1305998791,  ## 2011-05-21 17:26:31
  bits:       '1a44b9f2',
  nonce:       2504433986 )

pp b125552.hash
