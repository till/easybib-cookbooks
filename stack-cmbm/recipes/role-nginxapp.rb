include_recipe 'ies::role-generic'
include_recipe 'stack-cmbm::deploy-ruby'
include_recipe 'stack-cmbm::deploy-puma'

cookbook_file '/home/vagrant/.zshrc' do
  source 'zshrc'
  user 'vagrant'
  group 'vagrant'
  mode '0600'
end
