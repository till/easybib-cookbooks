actions :create

default_action :create

attribute :username, :default => '', :name_attribute => true
attribute :composer_token, :kind_of => String, :default => ''
attribute :ssh_public_key, :default => nil
