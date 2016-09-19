Chef::Application.fatal!('This recipe is vagrant only!') if is_aws

# AWS instances use RDS databases, which are not available in Vagrant
include_recipe 'ies::role-generic'
include_recipe 'ies-mysql'
include_recipe 'ies-mysql::dev'
include_recipe 'ies-zsh'
include_recipe 'redis'

# Install xvfb, see: https://github.com/easybib/ops/issues/197
package 'xvfb'

# Pull in the production role-* recipe.
include_recipe 'stack-cmbm::role-nginxapp'
include_recipe 'stack-cmbm::deploy-vagrant'
