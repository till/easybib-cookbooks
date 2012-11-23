node[:deploy].each do |application, deploy|

  Chef::Log.info("deploy::infolit - app: #{application}, role: #{node[:scalarium][:instance][:roles]}")

  next unless node[:scalarium][:cluster][:name] == 'InfoLit'

  case application
  when 'infolit'
    next unless node[:scalarium][:instance][:roles].include?('nginxphpapp')
  
  else
    Chef::Log.info("deploy::infolit - #{application} (in #{node[:scalarium][:cluster][:name]}) skipped")
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
