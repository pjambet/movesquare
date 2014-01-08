# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.
Mayors::Application.config.secret_key_base = ENV['CONFIG_SECRET_KEY_BASE'] || '693c3f1031e06528b7af47ad2e64e814a7a726ad1a99b17aadb15a8851aa5db3a6a314b337496f28e011e5d71dcffaa6d9659f42bd1cf7467f227ba7f30ee254'
