instance_roles = get_instance_roles()
cluster_name   = get_cluster_name()

node[:deploy].each do |application, deploy|

  Chef::Log.info("deploy::bibcd - app: #{application}, role: #{instance_roles}")
  Chef::Log.info("deploy::bibcd - Deployment started.")
  Chef::Log.info("deploy::bibcd - Deploying as user: #{deploy[:user]} and #{deploy[:group]}")

  opsworks_deploy_user do
    deploy_data deploy
    app application
  end

  opsworks_deploy_dir do
    user  deploy[:user]
    group deploy[:group]
    path  deploy[:deploy_to]
  end

  opsworks_deploy do
    deploy_data deploy
    app application
  end
  
  execute "ls" do
    user "www-data"
    cwd "#{deploy[:deploy_to]}/current"
    command "ls -laR"
  end
  
end
