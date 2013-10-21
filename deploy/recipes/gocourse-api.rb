include_recipe "php-fpm::service"
include_recipe "pecl-manager::service"

node['deploy'].each do |application, deploy|

  next unless allow_deploy(application, 'api', 'api-server')

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

  link "/etc/init.d/pecl-manager" do
    to "#{deploy["current_path"]}/bin/workers"
  end

  service "pecl-manager" do
    action :restart
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
