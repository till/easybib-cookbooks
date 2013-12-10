include_recipe "php-fpm::service"
include_recipe "nginx-app::service"

node['deploy'].each do |application, deploy|

  if application == 'sitescraper'
    next unless allow_deploy(application, 'sitescraper', 'nginxphpapp')
  end

  if application == 'worldcat'
    next unless allow_deploy(application, 'worldcat', 'nginxphpapp')
  end

  env_conf = ''
  if has_env?(application)
    env_conf = get_env_for_nginx(application)
  end

  Chef::Log.info("deploy::#{application} - Deployment started.")
  Chef::Log.info("deploy::#{application} - Deploying as user: #{deploy[:user]} and #{deploy[:group]}")

  opsworks_deploy_dir do
    user  deploy["user"]
    group deploy["group"]
    path  deploy["deploy_to"]
  end

  opsworks_deploy do
    deploy_data deploy
    app application
  end

  easybib_nginx config do
    config_template "internal-api.conf.erb"
    domain_name deploy['domains'].join(' ')
    doc_root deploy['document_root']
    access_log      "off"
    nginx_extras    nginx_extras
    routes_enabled  node["nginx-app"][application]["routes_enabled"]
    routes_denied   node["nginx-app"][application]["routes_denied"]
    notifies :restart, "service[nginx]", :delayed
  end

  service "php-fpm" do
    action :reload
  end

end
