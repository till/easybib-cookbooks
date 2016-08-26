actions :install
default_action :install

attribute :name, :kind_of => String, :name_attribute => true
attribute :package_name, :kind_of => String, :default => nil
attribute :package_prefix, :kind_of => String, :default => nil
