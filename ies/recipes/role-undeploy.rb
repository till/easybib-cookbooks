return unless is_aws

node['deploy'].each do |application, deploy|

  application_root_dir = "#{deploy_data['deploy_to']}/current"

  easybib_crontab application do
    action :delete
  end

  easybib_supervisor application do
    supervisor_file "#{application_root_dir}/deploy/supervisor.json"
    action :delete
  end
end
