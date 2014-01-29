action :deploy do
  app = new_resource.app
  deploy_data = new_resource.deploy_data
  application_root_dir = "#{deploy_data['deploy_to']}/current"

  opsworks_deploy do
    deploy_data deploy_data
    app app
  end

  execute "Setting Crontab from App File" do
    user "www-data"
    cwd deploy_data['deploy_to']
    command "crontab -u www-data #{deploy_data['deploy_to']}/current/deploy/crontab"
    only_if { ::File.exists?("#{deploy_data['deploy_to']}/current/deploy/crontab") }
  end

  import_file_path = "#{application_root_dir}/deploy/#{node['easybib_deploy']['gearman_file']}"

  Chef::Log.debug("easybib_deploy - import_file_path we are looking for is #{import_file_path}")

  pecl_manager_script "Setting up Pecl Manager" do
    dir                application_root_dir
    envvar_file        import_file_path
    envvar_json_source new_resource.envvar_json_source
    only_if { ::File.exists?(import_file_path) }
  end

  new_resource.updated_by_last_action(true)

end
