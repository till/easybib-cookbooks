actions :deploy

default_action :deploy

attribute :app, :default => {}
attribute :deploy_data, :default => {}
attribute :envvar_json_source, :kind_of => String, :default => nil
attribute :cronjob_role, :kind_of => String, :default => nil
attribute :supervisor_role, :kind_of => String, :default => nil
attribute :instance_roles, :default => []
