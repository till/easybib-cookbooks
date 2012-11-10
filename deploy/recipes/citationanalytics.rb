include_recipe "php-fpm::service"

instance_roles = node[:scalarium][:instance][:roles]

node[:deploy].each do |application, deploy|

  Chef::Log.debug("deploy::easybib - app: #{application}, role: #{instance_roles}")
  Chef::Log.debug("Deploying as user: #{deploy[:user]}")

  next unless node[:scalarium][:cluster][:name] == 'Citation Analytics'

  case application
  when 'citation_anlytics'
    next unless instance_roles.include?('elasticsearch')
  else
    Chef::Log.debug("deploy::analytics - #{application} (in #{node[:scalarium][:cluster][:name]}) skipped")
    next
  end

  Chef::Log.debug("deploy::analytics - Deployment started.")

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
