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

  # Using "gocourse" and "getcourse", so we dont have to update/rename everything
  # at the same moment.
  # TODO: Remove the gocourse-part when all stacks have a 'getcourse' binary deployed.
  
  ["gocourse", "getcourse"].each do |cron_app_name|
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
