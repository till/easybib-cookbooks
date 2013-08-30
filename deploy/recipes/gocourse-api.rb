include_recipe "php-fpm::service"

cluster_name   = get_cluster_name()
instance_roles = get_instance_roles()

node["deploy"].each do |application, deploy|

  next unless deploy["deploying_user"]

  case application
  when 'api'
    next unless instance_roles.include?('api-server')
  else
    next
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

  service "php-fpm" do
    action :reload
  end

  cron "clean-up changes" do
    minute "0"
    hour "0"
    weekday "1"
    user deploy["user"]
    home node["deploy"][application]["home"]
    mailto node["sysop_email"]
    command "cd /srv/www/#{application}/current && ./bin/gocourse cleanup changes"
  end
end
