unless is_aws
  return
end

node['deploy'].each do |application, deploy|
  application_root_dir = "#{deploy['deploy_to']}/current"

  easybib_crontab application do
    app application
    crontab_user node['easybib_deploy']['crontab_user']
    crontab_file "#{application_root_dir}/deploy/crontab"
    action :delete
  end
end
