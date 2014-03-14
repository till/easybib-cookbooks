include_recipe "php-fpm::service"

node['deploy'].each do |application, deploy|

  next unless allow_deploy(application, 'api', 'api-server')

  opsworks_deploy_dir do
    user  deploy["user"]
    group deploy["group"]
    path  deploy["deploy_to"]
  end

  easybib_deploy "getcourse-api" do
    deploy_data deploy
    app application
    envvar_json_source "getcourse"
  end

  service "php-fpm" do
    action :reload
  end

  cron "clean-up changes (getcourse, #{application}) " do
    minute "0"
    hour "0"
    weekday "1"
    user deploy["user"]
    home node["deploy"][application]["home"]
    mailto node["sysop_email"]
    command "cd /srv/www/#{application}/current && ./bin/getcourse cleanup changes"
    only_if do
      File.exist?("/srv/www/#{application}/current/bin/getcourse")
    end
  end

  cron "resume documents (getcourse, #{application}) " do
    minute "*/10"
    user deploy["user"]
    home node["deploy"][application]["home"]
    mailto node["sysop_email"]
    command "cd /srv/www/#{application}/current && ./bin/getcourse resume documents"
    only_if do
      File.exist?("/srv/www/#{application}/current/bin/getcourse")
    end
  end
end
