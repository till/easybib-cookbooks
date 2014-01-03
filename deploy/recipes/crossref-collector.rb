node['deploy'].each do |application, deploy|

  next unless allow_deploy(application, 'crossref-collector', 'crossref-www')

  opsworks_deploy_dir do
    user  deploy["user"]
    group deploy["group"]
    path  deploy["deploy_to"]
  end

  opsworks_deploy do
    deploy_data deploy
    app application
  end
  
  cron "trigger crossref collector cronjob (application #{application} ) " do
    minute "0"
    user deploy["user"]
    home node["deploy"][application]["home"]
    mailto node["sysop_email"]
    command "cd /srv/www/#{application}/current && ./bin/crossref"
    only_if do
      File.exists?("/srv/www/#{application}/current/bin/crossref")
    end
  end
end
