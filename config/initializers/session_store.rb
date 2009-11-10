# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_topicture_session',
  :secret      => 'a32b1d286ac84bf820aea5e2725b993122ee52b374b32c521af6864db218bea9f78341f724b1a4fe8be1f3fc609f88f8504acc2749f5424af80a906de7a2d7a8'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
