include_recipe 'ies-mysql'
include_recipe 'ies-mysql::dev'
include_recipe 'stack-cmbm::role-nginxapp'

cookbook_file '/home/vagrant/.zshrc' do
  source 'zshrc'
  user 'vagrant'
  group 'vagrant'
  mode '0600'
end
