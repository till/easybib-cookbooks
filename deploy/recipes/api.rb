include_recipe "php-fpm::service"
include_recipe "nginx-app::service"

node['deploy'].each do |application, deploy|

  next unless allow_deploy(application, 'api', 'nginxphpapp')

  Chef::Log.info("deploy::api- Deployment started.")
  Chef::Log.info("deploy::api - Deploying as user: #{deploy[:user]} and #{deploy[:group]}")

  opsworks_deploy_dir do
    user  deploy["user"]
    group deploy["group"]
    path  deploy["deploy_to"]
  end

  easybib_nginx "api" do
    config_template "silex.conf.erb"
    aws true
    doc_root 'web'
    notifies :restart, "service[nginx]", :delayed
  end

  opsworks_deploy do
    deploy_data deploy
    app application
  end

  service "php-fpm" do
    action :reload
  end

end
