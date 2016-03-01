action :undeploy do
  app = new_resource.app
  deploy_data = new_resource.deploy_data
  cronjob_role = new_resource.cronjob_role
  instance_roles = new_resource.instance_roles
  supervisor_role = new_resource.supervisor_role

  cronjob_role = node['easybib_deploy']['cronjob_role'] if cronjob_role.nil?
  instance_roles = ::EasyBib.get_instance_roles(node) if instance_roles.empty?

  application_root_dir = "#{deploy_data['deploy_to']}/current"
  document_root_dir = "#{application_root_dir}/#{deploy_data['document_root']}/"

  easybib_crontab "#{app}_#{new_resource.cronjob_role}" do
    crontab_file "#{application_root_dir}/deploy/crontab"
    app app
    action :delete
  end

  new_resource.updated_by_last_action(true)

end
