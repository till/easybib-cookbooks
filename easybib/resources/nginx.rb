actions :setup, :remove

default_action :setup

attribute :app_name, :kind_of => String, :name_attribute => true
attribute :config_template, :kind_of => String, :required => true
attribute :doc_root, :kind_of => String, :default => 'www'
attribute :access_log, :kind_of => String, :default => 'off'
attribute :domain_name, :kind_of => String, :default => nil
attribute :htpasswd, :kind_of => String, :default => nil
attribute :deploy_dir, :kind_of => String, :default => nil
attribute :app_dir, :kind_of => String, :default => nil
attribute :default_router, :kind_of => String, :default => nil
attribute :listen_opts, :kind_of => String, :default => nil
attribute :cookbook, :kind_of => String, :default => 'nginx-app'
