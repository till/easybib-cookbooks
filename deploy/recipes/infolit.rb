include_recipe "php-fpm::service"

instance_roles = node[:scalarium][:instance][:roles]

node[:deploy].each do |application, deploy|

  next unless node[:scalarium][:cluster][:name] == 'InfoLit'

  Chef::Log.debug("deploy::infolit - app: #{application}, role: #{instance_roles}")
  Chef::Log.debug("Deploying as user: #{deploy[:user]}")

  case application
  when 'infolit'
    next unless instance_roles.include?('nginxphpapp')  
  else
    Chef::Log.debug("deploy::infolit - #{application} (in #{node[:scalarium][:cluster][:name]}) skipped")
    next
  end

  Chef::Log.debug("deploy::infolit - Deployment started.")

  scalarium_deploy_dir do
    user  deploy[:user]
    group deploy[:group]
    path  deploy[:deploy_to]
  end

  scalarium_deploy do
    deploy_data deploy
    app application
  end

  service "php-fpm" do
    action :reload
  end

end
