include_recipe "php-fpm::service"

node[:deploy].each do |application, deploy|

  Chef::Log.info("deploy::infolit - app: #{application}, role: #{node[:opsworks][:instance][:layers]}")

  next unless node[:opsworks][:stack][:name] == 'InfoLit'

  case application
  when 'infolit'
    next unless node[:opsworks][:instance][:layers].include?('nginxphpapp')
  
  else
    Chef::Log.info("deploy::infolit - #{application} (in #{node[:opsworks][:stack][:name]}) skipped")
    next
  end

  Chef::Log.info("deploy::infolit - Deployment started.")
  Chef::Log.info("deploy::infolit - Deploying as user: #{deploy[:user]} and #{deploy[:group]}")

  opsworks_deploy_dir do
    user  deploy[:user]
    group deploy[:group]
    path  deploy[:deploy_to]
  end

  opsworks_deploy do
    deploy_data deploy
    app application
  end

  service "php-fpm" do
    action :reload
  end

end
