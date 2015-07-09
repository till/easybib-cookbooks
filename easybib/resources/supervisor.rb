actions :create

default_action :create

attribute :app, :kind_of => String, :default => ''
attribute :app_dir, :kind_of => String, :default => ''
attribute :supervisor_file, :kind_of => String, :default => ''
attribute :user, :kind_of => String, :default => ''
attribute :supervisor_role, :kind_of => String, :default => nil
