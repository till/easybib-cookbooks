actions :create, :delete

default_action :create

attribute :app, :default => ''
attribute :crontab_file, :kind_of => String, :default => ''
attribute :instance_roles, :default => []
attribute :crontab_user, :kind_of => String, :default => 'www-data'
