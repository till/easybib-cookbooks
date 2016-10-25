#!/usr/bin/ruby
require 'openssl'

def encrypt_pbkdf2(pw, salt_length = 16, iterations = 10)
  key_length = 20
  salt       = OpenSSL::Random.random_bytes(salt_length).unpack('H*')[0]
  hash       = OpenSSL::PKCS5.pbkdf2_hmac_sha1(pw, salt, iterations, key_length).unpack('H*')[0]
  "-pbkdf2-#{hash},#{salt},#{iterations}"
end

if ARGV[0].nil?
  puts 'Call: ./pbkdf2.rb password'
else
  puts encrypt_pbkdf2(ARGV[0])
end
