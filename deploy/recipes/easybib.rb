include_recipe "php-fpm::service"

instance_roles = node[:scalarium][:instance][:roles]

node[:deploy].each do |application, deploy|

  Chef::Log.debug("deploy::easybib - app: #{application}, role: #{instance_roles}")
  Chef::Log.debug("Deploying as user: #{deploy[:user]}")

  case application
  when 'easybib'
    if !['EasyBib', 'EasyBib Playground', 'Fruitkid'].include?(node[:scalarium][:cluster][:name])
      next
    end
    if !instance_roles.include?('nginxphpapp') && !instance_roles.include?('testapp')
      next
    end

  when 'easybib_api'
    next unless instance_roles.include?('bibapi')

  when 'gearmanworker'
    next unless instance_roles.include?('gearman-worker')

  when 'sitescraper'
    next unless instance_roles.include?('sitescraper')

  else
    Chef::Log.debug("deploy::easybib - #{application} (in #{node[:scalarium][:cluster][:name]}) skipped")
    next
  end

  Chef::Log.debug("deploy::easybib - Deployment started.")

  scalarium_deploy_dir do
    user  deploy[:user]
    group deploy[:group]
    path  deploy[:deploy_to]
  end

  scalarium_deploy do
    deploy_data deploy
    app application
  end

  if application == 'gearmanworker'
    next
  end

  service "php-fpm" do
    action :reload
  end

end
