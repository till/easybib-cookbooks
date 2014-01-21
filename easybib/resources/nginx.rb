actions :setup, :remove

default_action :setup

attribute :app_name, :kind_of => String, :name_attribute => true
attribute :config_template, :kind_of => String, :required => true
attribute :config_name, :kind_of => String, :default => ''
attribute :doc_root, :kind_of => String, :default => 'www'
attribute :access_log, :kind_of => String, :default => 'off'
attribute :domain_name, :kind_of => String, :default => ''
attribute :domain_config, :kind_of => String, :default => ''
attribute :database_config, :kind_of => String, :default => ''
attribute :env_config, :kind_of => String, :default => ''
attribute :nginx_extras, :kind_of => String, :default => ''
attribute :routes_enabled, :default => {}
attribute :routes_denied, :default => {}
