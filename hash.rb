require 'digest'


p Digest::SHA256.hexdigest( 'Hello, Cryptos!' )


p Digest::SHA256.hexdigest( 'Hello, Cryptos! - Hello, Cryptos! - Hello, Cryptos!' )


p Digest::SHA256.hexdigest( 'Your Name Here' )
p Digest::SHA256.hexdigest( 'Data Data Data Data' )

p Digest::SHA256.hexdigest( <<TXT )
  Data Data Data Data Data Data
  Data Data Data Data Data Data
  Data Data Data Data Data Data
  Data Data Data Data Data Data
  Data Data Data Data Data Data
TXT


p Digest::SHA256.hexdigest( 'Hello, Cryptos!' ).length
p Digest::SHA256.hexdigest( 'Hello, Cryptos! - Hello, Cryptos! - Hello, Cryptos!' ).length


hex = Digest::SHA256.hexdigest( 'Hello, Cryptos!' )
p hex

p hex.to_i( 16 )

p hex.to_i( 16 ).to_s( 2 )

### format helper / in group of four
def fmt_hash( str )
  ## format in groups of four (4) separated by space
  ##  e.g.  ccac7787fa7fafaa16467755f9ee444467667366cccceede
  ##     :  ccac 7787 fa7f afaa 1646 7755 f9ee 4444 6766 7366 cccc eede
  str.reverse.gsub( /(.{4})/, '\1 ').reverse.strip
end

p fmt_hash( hex.to_i( 16 ).to_s( 2 ) )
p hex.to_i( 16 ).to_s( 2 ).length    # 254   - note: missing two leading 00
