include_recipe 'php-fpm::service'
include_recipe 'nginx-app::service'

easybib_deploy_manager get_cluster_name do
  apps node['stack-academy']['applications']
  deployments node['deploy']
  nginx_restart :reload
  php_restart node['easybib-deploy']['php-fpm']['restart-action']
end
