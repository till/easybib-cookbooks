unless is_aws
  return
end

node['deploy'].each do |application, deploy|
  easybib_crontab application do
    app application
    crontab_user node['easybib_deploy']['crontab_user']
    action :delete
  end
end
