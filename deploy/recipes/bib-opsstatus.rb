node['deploy'].each do |application, deploy|

  next unless allow_deploy(application, 'bib-opsstatus')

  Chef::Log.info("deploy::bib-opsstatus - Deployment started.")
  Chef::Log.info("deploy::bib-opsstatus - Deploying as user: #{deploy["user"]} and #{deploy["group"]}")

  opsworks_deploy_user do
    deploy_data deploy
    app application
  end

  opsworks_deploy_dir do
    user  deploy["user"]
    group deploy["group"]
    path  deploy["deploy_to"]
  end

  opsworks_deploy do
    deploy_data deploy
    app application
  end

  service "php-fpm" do
    action :reload
  end

end
