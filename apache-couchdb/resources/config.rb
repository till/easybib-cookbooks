actions :add, :remove
default_action :add if defined?(default_action) # Chef > 10.8

# Needed for Chef versions < 0.10.10
def initialize(*args)
  super
  @action = :add

  # Net::HTTP
  @http = nil

  # hostname:port of CouchDB
  @host = nil
  @port = nil

  # the entire configuration
  @couchdb_config = nil

  # basic auth
  @username = nil
  @password = nil
end

attribute :config, :kind_of => Hash
attribute :host, :kind_of => String, :default => '127.0.0.1'
attribute :port, :kind_of => Fixnum, :default => 5984
attribute :etc_dir, :kind_of => String, :default => '/etc/couchdb'
attribute :instance, :kind_of => Array
attribute :re_try, :kind_of => Fixnum, :default => 10
