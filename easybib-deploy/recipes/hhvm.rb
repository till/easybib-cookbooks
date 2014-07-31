include_recipe "hhvm-fcgi::service"
include_recipe "nginx-app::service"

node['deploy'].each do |application, deploy|

  if application == 'hhvm'
    next unless allow_deploy(application, 'hhvm', 'nginxphpapp')
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

  easybib_deploy application do
    deploy_data deploy
    app application
  end

  easybib_nginx app_name do
    config_template "hhvm.conf.erb"
    domain_name deploy['domains'].join(' ')
    doc_root deploy['document_root']
    env_config env_conf
    notifies :restart, "service[nginx]", :delayed
  end


  service "hhvm-fcgi" do
    action :reload
  end

end
