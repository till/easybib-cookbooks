# AWS instances use RDS databases, which are not available in Vagrant
include_recipe 'ies-mysql'
include_recipe 'ies-mysql::dev'

# Pull in the production role-* recipe.
include_recipe 'stack-cmbm::role-nginxapp'

# Deploy a specially crafted zshrc on Vagrant for development.
cookbook_file '/home/vagrant/.zshrc' do
  source 'zshrc'
  user 'vagrant'
  group 'vagrant'
  mode '0600'
end
