return unless is_aws

node['deploy'].each do |application, deploy|

  application_root_dir = "#{deploy_data['deploy_to']}/current"

  easybib_crontab application do
    app application
    crontab_user node['easybib_deploy']['crontab_user']
    action :delete
  end

  easybib_supervisor application do
    app application
    supervisor_file "#{application_root_dir}/deploy/supervisor.json"
    action :delete
  end
end
