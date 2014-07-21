action :deploy do
  app = new_resource.app
  deploy_data = new_resource.deploy_data
  application_root_dir = "#{deploy_data['deploy_to']}/current"

  opsworks_deploy do
    deploy_data deploy_data
    app app
  end

  easybib_crontab "#{app}_#{new_resource.cronjob_role}" do
    crontab_file "#{deploy_data['deploy_to']}/current/deploy/crontab"
    app app
    only_if do
      if new_resource.cronjob_role.nil?
        return true
      end
      if new_resource.instances_roles.include?(new_resource.cronjob_role)
        return true
      end
      return false
    end
  end

  easybib_gearmanw application_root_dir do
    envvar_json_source new_resource.envvar_json_source
  end

  easybib_envconfig app

  new_resource.updated_by_last_action(true)

end
