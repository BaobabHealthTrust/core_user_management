# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_core_user_management_session',
  :secret      => 'c11df025347e850fc98e57f785baa5ba2f1c07817247fe72df55d9fc978ad61aba7619cc3e69c00f4d6e98545a4bdb214bb5ca6d0024f9b167397c8dfa2ca372'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
