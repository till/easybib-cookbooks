actions :create

default_action :create

attribute :username, :name_attribute => true, :required => true
attribute :composer_token, :kind_of => String, :default => ''
attribute :home_dir, :kind_of => String, :required => true
