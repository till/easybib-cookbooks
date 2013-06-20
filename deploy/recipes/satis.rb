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
  
  directory "/mnt/satis-output/" do
    recursive true
    owner "www-data"
    group "www-data"
    mode  0755
    action :create
  end
  
  directory "/mnt/composer-tmp/" do
    recursive true
    owner "www-data"
    group "www-data"
    mode  0755
    action :create
  end
  
  directory "/mnt/srv/www/s3-syncer/" do
    recursive true
    owner "www-data"
    group "www-data"
    mode  0755
    action :create
  end
  
  execute "Fetching S3 Syncer" do
    not_if do
      ::File.exists?("/mnt/srv/www/s3-syncer/bin/syncer")
    end
    user "www-data"
    cwd "/mnt/srv/www/s3-syncer"
    code <<-SYNCER_EOM
    wget https://github.com/easybiblabs/s3-syncer/archive/master.tar.gz
    tar xf master.tar.gz --strip 1
    `which php` composer-AWS_S3.phar --no-interaction install --prefer-source --optimize-autoloader
    SYNCER_EOM
  end
  
  cron "satis run in cron" do
    minute "*/30"
    command "cd #{deploy[:deploy_to]}/current/ && sh update-dist.sh"
    user "www-data"
  end
  
end
