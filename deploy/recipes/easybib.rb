include_recipe "php-fpm::service"

instance_roles = get_instance_roles
cluster_name   = get_cluster_name

node["deploy"].each do |application, deploy|

  Chef::Log.info("deploy::easybib - app: #{application}, role: #{instance_roles}")

  case application
  when 'easybib'
    nginxphpapp_allowed = allow_deploy(application, 'easybib', 'nginxphpapp')
    testapp_allowed     = allow_deploy(application, 'easybib', 'testapp')
    if !nginxphpapp_allowed && !testapp_allowed
      next
    end

  when 'easybib_api'
    next unless allow_deploy(application, 'easybib_api', 'bibapi')

  when 'gearmanworker'
    next unless allow_deploy(application, 'gearmanworker', 'gearman-worker')

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

  easybib_deploy application do
    deploy_data deploy
    app application
  end

  next if application == 'gearmanworker'

  service "php-fpm" do
    action :reload
  end

end
