instance_roles = get_instance_roles()
cluster_name   = get_cluster_name()

node["deploy"].each do |application, deploy|

  Chef::Log.info("deploy::bibcd - request to deploy app: #{application}, role: #{instance_roles} in #{cluster_name}")

  next unless cluster_name == node["easybib"]["cluster_name"]

  case application
  when 'bibcd'
    next unless instance_roles.include?('bibcd')
    # quick fix for https://github.com/till/easybib-cookbooks/issues/72
    # since we set deploy["home"] for all apps, all apps are set, so we
    # have to check for sth else to make sure we are deploying the right app
    next unless deploy["deploying_user"]
  else
    Chef::Log.info("deploy::bibcd - #{application} (in #{cluster_name}) skipped")
    next
  end

  Chef::Log.info("deploy::bibcd - Deployment started.")
  Chef::Log.info("deploy::bibcd - Deploying as user: #{deploy["user"]} and #{deploy["group"]}")

#  To debug empty user/group problem with chef 11:
#  Chef::Log.debug("depoy::bibcd - deploy resource: " + deploy.inspect)

  opsworks_deploy_user do
    deploy_data deploy
    app application
  end

  opsworks_deploy_dir do
    user  deploy["user"]
    group deploy["group"]
    path  deploy["deploy_to"]
  end

  opsworks_deploy do
    deploy_data deploy
    app application
  end

  node['bibcd']['apps'].each do |appname, config|
    bibcd_app "adding bibcd app #{appname}" do
      action :add
      path "#{deploy["deploy_to"]}/current/"
      app_name appname
      config config
    end
  end

  service "php-fpm" do
    action :reload
  end

end
