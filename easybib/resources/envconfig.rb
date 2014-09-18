actions :create

default_action :create

attribute :app, :name_attribute => true
attribute :path, :kind_of => String, :default => nil
attribute :stackname, :kind_of => String, :default => 'getcourse'
