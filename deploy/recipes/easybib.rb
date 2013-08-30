include_recipe "php-fpm::service"

instance_roles = get_instance_roles()
cluster_name   = get_cluster_name()

node["deploy"].each do |application, deploy|

  Chef::Log.info("deploy::easybib - app: #{application}, role: #{instance_roles}")

  next unless deploy["deploying_user"]

  case application
  when 'easybib'
    if !['EasyBib', 'EasyBib Playground', 'Fruitkid', 'Fruitkid Playground'].include?(cluster_name)
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
    Chef::Log.info("deploy::easybib - #{application} (in #{cluster_name}) skipped")
    next
  end

  Chef::Log.info("deploy::easybib - Deployment started.")
  Chef::Log.info("deploy::easybib - Deploying as user: #{deploy["user"]} and #{deploy["group"]}")

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

  next if application == 'gearmanworker'

  service "php-fpm" do
    action :reload
  end

end
