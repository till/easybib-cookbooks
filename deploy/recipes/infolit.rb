instance_roles = node[:scalarium][:instance][:roles]
cluster_name   = node[:scalarium][:cluster][:name]

node[:deploy].each do |application, deploy|

  Chef::Log.info("deploy::infolit - app: #{application}, role: #{instance_roles}")

  next unless cluster_name == 'InfoLit'

  case application
  when 'infolit'
    next unless instance_roles.include?('nginxphpapp')
  
  else
    Chef::Log.info("deploy::infolit - #{application} (in #{cluster_name}) skipped")
    next
  end

  Chef::Log.info("deploy::infolit - Deployment started.")
  Chef::Log.info("deploy::infolit - Deploying as user: #{deploy[:user]} and #{deploy[:group]}")

  scalarium_deploy_dir do
    user  deploy[:user]
    group deploy[:group]
    path  deploy[:deploy_to]
  end

  scalarium_deploy do
    deploy_data deploy
    app application
  end

end
