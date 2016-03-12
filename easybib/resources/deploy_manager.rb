actions :deploy

default_action :deploy

attribute :app, :kind_of => String, :name_attribute => true
attribute :app_data, :kind_of => Hash
attribute :app_dir, :kind_of => String
attribute :deployments, :kind_of => Hash
attribute :php_restart, :default => :restart
attribute :nginx_restart, :default => :reload
