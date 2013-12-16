action :deploy do
  app = params[:app]
  deploy_data = params[:deploy_data]

  opsworks_deploy do
    deploy_data deploy_data
    app app
  end

  execute "Setting Crontab from App File" do
    user "www-data"
    cwd deploy_data[:deploy_to]
    command "crontab -u www-data #{deploy_data[:deploy_to]}/deploy/crontab"
    only_if do
      File.exists?("#{deploy_data[:deploy_to]}/deploy/crontab")
    end
  end

  new_resource.updated_by_last_action(true)
end
