action :deploy do
  app = new_resource.app
  deploy_data = new_resource.deploy_data
  cronjob_role = new_resource.cronjob_role
  instance_roles = new_resource.instance_roles
  supervisor_role = new_resource.supervisor_role

  cronjob_role = node['easybib_deploy']['cronjob_role'] if cronjob_role.nil?
  instance_roles = ::EasyBib.get_instance_roles(node) if instance_roles.empty?

  application_root_dir = "#{deploy_data['deploy_to']}/current"
  document_root_dir = "#{application_root_dir}/#{deploy_data['document_root']}/"

  opsworks_deploy_user do
    deploy_data deploy_data
    app app
  end

  opsworks_deploy_dir do
    user  deploy_data['user']
    group deploy_data['group']
    path  deploy_data['deploy_to']
  end

  opsworks_deploy do
    deploy_data deploy_data
    app app
  end

  # WARNING this has to take place before any gearman/supervisor/cronjob stuff
  # this generates .deploy_configuration, so all php commands relying on that
  # will fail otherwise.
  easybib_envconfig app

  easybib_crontab "#{app}_#{new_resource.cronjob_role}" do
    crontab_file "#{application_root_dir}/deploy/crontab"
    app app
    cronjob_role cronjob_role
    instance_roles instance_roles
  end

  easybib_supervisor "#{app}_supervisor" do
    supervisor_file "#{application_root_dir}/deploy/supervisor.json"
    app app
    app_dir application_root_dir
    user deploy_data['user']
    supervisor_role supervisor_role
    instance_roles instance_roles
  end

  easybib_gearmanw application_root_dir

  cookbook_file "#{document_root_dir}/robots.txt" do
    mode   '0644'
    cookbook 'easybib'
    source 'robots.txt'
    not_if { node['easybib_deploy']['envtype'] == 'production' }
  end

  new_resource.updated_by_last_action(true)

end
