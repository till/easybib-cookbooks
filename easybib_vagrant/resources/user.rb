actions :create

default_action :create

attribute :username, :default => '', :name_attribute => true
attribute :composer_token, :kind_of => String, :default => ''
attribute :home_dir, :kind_of => String, :default => nil
