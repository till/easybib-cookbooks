nodejs_npm 'sinopia-github' do
  path node['sinopia-github']['install_path']
  action :install
end
template File.join(node['sinopia']['confdir'], 'config.yaml') do
  source 'config.yaml.erb'
  notifies :restart, 'service[sinopia]', :delayed
end
