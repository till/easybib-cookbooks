actions :create, :delete

default_action :create

attribute :app, :kind_of => String, :name_attribute => true
attribute :crontab_file, :kind_of => String, :default => ''
attribute :instance_roles, :default => []
