include_recipe "php-fpm::service"

cluster_name   = get_cluster_name()
instance_roles = get_instance_roles()

node["deploy"].each do |application, deploy|

  next unless deploy["deploying_user"]
  next unless cluster_name == node["easybib"]["cluster_name"]

  case application
  when 'infolit'
    next unless instance_roles.include?('nginxphpapp')
  else
    Chef::Log.info("deploy::infolit - #{application} (in #{cluster_name}) skipped")
    next
  end

  Chef::Log.info("deploy::infolit - Deployment started.")
  Chef::Log.info("deploy::infolit - Deploying as user: #{deploy["user"]} and #{deploy["group"]}")

  opsworks_deploy_dir do
    user  deploy["user"]
    group deploy["group"]
    path  deploy["deploy_to"]
  end

  opsworks_deploy do
    deploy_data deploy
    app application
  end

  service "php-fpm" do
    action :reload
  end

end
