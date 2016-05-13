Chef::Application.fatal!('This recipe is vagrant only!') if is_aws

# AWS instances use RDS databases, which are not available in Vagrant
include_recipe 'ies-mysql'
include_recipe 'ies-mysql::dev'

# Pull in the production role-* recipe.
include_recipe 'stack-cmbm::role-nginxapp'
