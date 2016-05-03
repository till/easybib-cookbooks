actions :install
default_action :install

attribute :ruby_version, :kind_of => String, :name_attribute => true
attribute :rbenv_user, :kind_of => String, :default => 'root'
attribute :gems, :kind_of => Array, :default => []
