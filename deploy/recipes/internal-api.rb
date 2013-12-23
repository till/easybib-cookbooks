include_recipe "php-fpm::service"
include_recipe "nginx-app::service"

applications = ["crossref_service", "sitescraper", "worldcat"]

node['deploy'].each do |application, deploy|

  next unless applications.include?(application)

  if application == 'crossref_service'
    next unless allow_deploy(application, 'crossref-www')
  end

  if application == 'sitescraper'
    next unless allow_deploy(application, 'sitescraper')
  end

  if application == 'worldcat'
    next unless allow_deploy(application, 'worldcat')
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

  easybib_nginx application do
    config_template "internal-api.conf.erb"
    domain_name deploy['domains'].join(' ')
    doc_root deploy['document_root']
    access_log      "off"
    routes_enabled  node["nginx-app"][application]["routes_enabled"]
    routes_denied   node["nginx-app"][application]["routes_denied"]
    notifies :restart, "service[nginx]", :delayed
  end

  service "php-fpm" do
    action :reload
  end

end
