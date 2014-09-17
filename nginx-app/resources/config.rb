actions :create, :delete

default_action :create

attribute :enable_fastcgi, :kind_of => [TrueClass, FalseClass], :default => true
attribute :delete_default, :kind_of => [TrueClass, FalseClass], :default => true
attribute :cookbook, :kind_of => String, :default => 'nginx-app'
attribute :template, :kind_of => String, :default => 'nginx.conf.erb'
attribute :nginx_user, :kind_of => String
attribute :nginx_group, :kind_of => String
