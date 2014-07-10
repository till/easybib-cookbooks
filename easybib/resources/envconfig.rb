actions :create

default_action :create

attribute :app, :required => true
attribute :path, :kind_of => String, :default => nil
