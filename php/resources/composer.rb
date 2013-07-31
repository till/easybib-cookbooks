actions :install, :setup

default_action :install

# deploy to is the target_directory
attribute :deploy_to, :kind_of => String, :name_attribute => true
