include_recipe "php-fpm::service"
include_recipe "nginx-app::service"

cluster_name   = get_cluster_name

node['deploy'].each do |application, deploy|

  case application
  when 'schoolanalytics'
    next unless allow_deploy(application, 'schoolanalytics')
  else
    Chef::Log.info("deploy::housekeeping - #{application} (in #{cluster_name}) skipped")
    next
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

end
