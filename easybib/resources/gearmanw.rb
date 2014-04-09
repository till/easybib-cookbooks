actions :create

default_action :create

attribute :application_root_dir, :name_attribute => true
attribute :envvar_json_source, :kind_of => String, :default => nil
