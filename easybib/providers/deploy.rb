action :deploy do
  app = new_resource.app
  deploy_data = new_resource.deploy_data

  opsworks_deploy do
    deploy_data deploy_data
    app app
  end

  execute "Setting Crontab from App File" do
    user "www-data"
    cwd deploy_data[:deploy_to]
    command "crontab -u www-data #{deploy_data[:deploy_to]}/current/deploy/crontab"
    only_if { ::File.exists?("#{deploy_data[:deploy_to]}/current/deploy/crontab") }
  end

  import_file_path = "#{deploy_data[:deploy_to]}/current/deploy/pecl-manager-env"

  pecl_manager_script "Setting up Pecl Manager" do
    dir deploy_data[:deploy_to]
    envvar_file import_file_path
    only_if { ::File.exists?("#{deploy_data[:deploy_to]}/current/deploy/pecl-manager-env") }
  end

  new_resource.updated_by_last_action(true)

end
