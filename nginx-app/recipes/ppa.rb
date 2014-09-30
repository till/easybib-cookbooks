include_recipe 'apt::ppa'

easybib_launchpad node['nginx-app']['ppa'] do
  action :discover
end
