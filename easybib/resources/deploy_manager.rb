actions :deploy

default_action :deploy

attribute :stack, :kind_of => String, :name_attribute => true
attribute :apps, :kind_of => Hash
attribute :deployments, :kind_of => Hash
attribute :nginx_restart
attribute :php_restart
