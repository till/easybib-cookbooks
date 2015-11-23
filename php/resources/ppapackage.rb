actions :install
default_action :install

attribute :name, :kind_of => String, :named_attribute => true
attribute :config, :kind_of => Hash, :default => nil
attribute :package_name, :kind_of => String, :default => nil
