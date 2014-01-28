actions :create

default_action :create

attribute :dir, :kind_of => String, :required => true
attribute :envvar_file, :kind_of => String, :required => true
attribute :envvar_source, :kind_of => String, :default => nil
