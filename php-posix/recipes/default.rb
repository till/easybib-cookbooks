include_recipe 'apt::ppa'
include_recipe 'apt::easybib'

case node['lsb']['codename']
when 'precise'
  package 'php5-easybib-posix'
else
  Chef::Log.debug('ext/posix is not available or included')
end
