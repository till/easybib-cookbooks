action :undeploy do
  # executing undeploy event from chef

  app = new_resource.app
  deploy_data = new_resource.deploy_data
  application_root_dir = "#{deploy_data['deploy_to']}/current"

  easybib_crontab "#{app}_#{new_resource.cronjob_role}" do
    crontab_file "#{application_root_dir}/deploy/crontab"
    app app
    action :delete
  end

  new_resource.updated_by_last_action(true)

end
