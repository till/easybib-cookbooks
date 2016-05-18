actions :install
default_action :install

attribute :name, :kind_of => String, :name_attribute => true
attribute :rbenv_owner, :kind_of => String, :default => node['ies-rbenv']['rbenv']['owner']
attribute :rbenv_group, :kind_of => String, :default => node['ies-rbenv']['rbenv']['group']
attribute :rbenv_version, :kind_of => String, :default => node['ies-rbenv']['rbenv']['version']
attribute :ruby_build_version, :kind_of => String, :default => node['ies-rbenv']['ruby-build']['version']
attribute :install_to, :kind_of => String, :default => node['ies-rbenv']['rbenv']['install_to']
attribute :opsworks_ruby, :kind_of => String, :default => node['ies-rbenv']['rbenv']['opsworks']['ruby']
attribute :rbenv_users, :kind_of => Array
attribute :rubies, :kind_of => Array
attribute :gems, :kind_of => Array
