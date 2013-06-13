cluster_name   = get_cluster_name()
instance_roles = get_instance_roles()

node[:deploy].each do |application, deploy|

  Chef::Log.info("deploy::satis - app: #{application}, role: #{instance_roles}")

  next unless cluster_name == node["easybib"]["cluster_name"]

  case application
  when 'satis'
    next unless instance_roles.include?('satis')
  else
    Chef::Log.info("deploy::satis - #{application} (in #{cluster_name}) skipped")
    next
  end

  Chef::Log.info("deploy::satis- Deployment started.")
  Chef::Log.info("deploy::satis - Deploying as user: #{deploy[:user]} and #{deploy[:group]} to #{deploy[:deploy_to]}")

  opsworks_deploy_dir do
    user  deploy[:user]
    group deploy[:group]
    path  deploy[:deploy_to]
  end

  opsworks_deploy do
    deploy_data deploy
    app application
  end
  
  #cronjob
  #initial run

end
