action :deploy do
  app = new_resource.app
  deploy_data = new_resource.deploy_data
  application_root_dir = "#{deploy_data['deploy_to']}/current"

  easybib_opsworks_deploy app do
    deploy_data deploy_data
    app app
  end

  easybib_crontab app do
    crontab_file "#{deploy_data['deploy_to']}/current/deploy/crontab"
    app app
  end

  easybib_gearmanw application_root_dir do
    envvar_json_source new_resource.envvar_json_source
  end

  new_resource.updated_by_last_action(true)

end
