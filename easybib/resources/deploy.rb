actions :deploy

default_action :deploy

attribute :app, :kind_of => String, :name_attribute => true
attribute :deploy_data, :default => {}
