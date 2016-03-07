unless is_aws
  return
end

node['deploy'].each do |application, deploy|
  easybib_crontab application do
    app application
    crontab_user node['easybib_deploy']['crontab_user']
    action :delete
  end

  easybib_supervisor application do
    app application
    app_dir = EasyBib::Config.get_appdata(node, 'www', 'app_dir')
    supervisor_file "#{app_dir}/current/deploy/supervisor.json"
    action :delete
  end
end
