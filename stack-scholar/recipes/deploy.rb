include_recipe 'php-fpm::service'
include_recipe 'nginx-app::service'

node.set['stack-scholar']['applications']['scholar']['layer'] = [
  'nginxphpapp',
  node['easybib_deploy']['supervisor_role']
]

unless node['haproxy']['websocket_layers'].nil?
  node.set['stack-scholar']['applications']['scholar_realtime'] = node['haproxy']['websocket_layers'].keys
end

easybib_deploy_manager get_cluster_name do
  apps node['stack-scholar']['applications']
  deployments node['deploy']
end
