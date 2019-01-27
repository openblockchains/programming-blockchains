# (Crypto) Hash


Let's build blockchains from scratch (zero) step by step.

Let's start with crypto hashes.

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
