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

  #for .git and .gitconfig
  execute "Make sure #{deploy[:user]} owns his home dir" do
    command "chown #{deploy[:user]} ~#{deploy[:user]}"
  end

  execute "adding github oauth token to #{deploy[:user]}'s git config" do
    user  deploy[:user]
    command "git config --add github.accesstoken #{node[:composer][:oauth_key]}"
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
  
  #execute "composer install" do
  #  cwd "#{deploy[:deploy_to]}/current"
  #  command "php composer.phar install"
  #end
  
  
  #cronjob
  #initial run

end
