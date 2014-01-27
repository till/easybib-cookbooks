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
  end

  service "php-fpm" do
    action :reload
  end

  ["getcourse"].each do |cron_app_name|
    cron "clean-up changes (#{cron_app_name}, #{application}) " do
      minute "0"
      hour "0"
      weekday "1"
      user deploy["user"]
      home node["deploy"][application]["home"]
      mailto node["sysop_email"]
      command "cd /srv/www/#{application}/current && ./bin/#{cron_app_name} cleanup changes"
      only_if do
        File.exists?("/srv/www/#{application}/current/bin/#{cron_app_name}")
      end
    end

    cron "resume documents (#{cron_app_name}, #{application}) " do
      minute "*/10"
      user deploy["user"]
      home node["deploy"][application]["home"]
      mailto node["sysop_email"]
      command "cd /srv/www/#{application}/current && ./bin/#{cron_app_name} resume documents"
      only_if do
        File.exists?("/srv/www/#{application}/current/bin/#{cron_app_name}")
      end
    end
  end
end
