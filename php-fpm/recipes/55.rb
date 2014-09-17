include_recipe 'apt::ppa'
include_recipe 'apt::easybib'

easybib_launchpad node['apt']['easybib']['ppa-php55'] do
  action :discover
end

commands = [
  'apt-get update',
  'apt-get upgrade -y'
]

commands.each do |cmd|
  execute cmd
end
