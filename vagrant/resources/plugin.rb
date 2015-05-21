actions :install, :remove, :uninstall

default_action :install

attribute :plugin_name, :name_attribute => true
attribute :version, :kind_of => [String]
attribute :installed, :kind_of => [TrueClass, FalseClass]
attribute :installed_version, :kind_of => [String]
