include_recipe 'php-fpm::service'
include_recipe 'nginx-app::service'

node['stack-academy']['applications'].each do |application, settings|
  easybib_deploy_manager application do |variable|
    app_data settings
    app_dir app_dir
    deployments node['deploy']
  end
end
