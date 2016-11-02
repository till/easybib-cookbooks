actions :create, :delete

default_action :create

attribute :path, :kind_of => String, :name_attribute => true
attribute :servers, :kind_of => Array, :default => []
