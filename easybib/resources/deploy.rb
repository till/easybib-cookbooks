actions :deploy

default_action :deploy

attribute :app, :default => {}
attribute :deploy_data, :default => {}
attribute :envvar_source, :kind_of => String, :default => nil
