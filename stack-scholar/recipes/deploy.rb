include_recipe 'php-fpm::service'
include_recipe 'nginx-app::service'

#
# An attempt to make sure that the php prefix given is the prefix
# chosen for php-cli at the end of an install
php_package_prefix = node['php']['ppa']['package_prefix'].gsub(/php/, '')
php_alternatives = []
php_alternatives << '/usr/bin/update-alternatives'
php_alternatives << '--set'
php_alternatives << 'php'
php_alternatives << "/usr/bin/php#{php_package_prefix}"
execute 'update-alternatives' do
  Chef::Log.info("Choosing alternative php with #{php_alternatives.join(' ')} !!! ")
  command php_alternatives.join(' ')
  action :nothing
end
# End of something
#

node.set['stack-scholar']['applications']['scholar']['layer'] = [
  'nginxphpapp',
  node['easybib_deploy']['supervisor_role']
]

unless node['haproxy']['websocket_layers'].nil?
  node.set['stack-scholar']['applications']['scholar_realtime']['layer'] = node['haproxy']['websocket_layers'].keys
end

Chef::Log.info(node['stack-scholar']['applications'])

easybib_deploy_manager get_cluster_name do
  apps node['stack-scholar']['applications']
  deployments node['deploy']
  ## execute the php-cli fix at the end
  notifies :run, 'execute[update-alternatives]', :delayed
end
