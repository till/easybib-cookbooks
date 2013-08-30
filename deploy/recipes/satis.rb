cluster_name   = get_cluster_name()
instance_roles = get_instance_roles()

node["deploy"].each do |application, deploy|

  Chef::Log.info("deploy::satis - app: #{application}, role: #{instance_roles}")

  next unless deploy["deploying_user"]
  next unless cluster_name == node["easybib"]["cluster_name"]

  case application
  when 'satis'
    next unless instance_roles.include?('satis')
  else
    Chef::Log.info("deploy::satis - #{application} (in #{cluster_name}) skipped")
    next
  end

  Chef::Log.info("deploy::satis - Deploying as user: #{deploy["user"]} and #{deploy["group"]} to #{deploy["deploy_to"]}")

  opsworks_deploy_dir do
    user  deploy["user"]
    group deploy["group"]
    path  deploy["deploy_to"]
  end

  opsworks_deploy do
    deploy_data deploy
    app application
  end

  %w{"/mnt/satis-output/" "/mnt/composer-tmp/" node['s3-syncer']['path']}.each do |dir|
    directory dir do
      recursive true
      owner "www-data"
      group "www-data"
      mode  0755
      action :create
    end
  end

  if File.exists?("#{node['s3-syncer']['path']}/bin/syncer")
    next
  end

  remote_file "#{node['s3-syncer']['path']}/syncer.tar.gz" do
    source node['s3-syncer']['source']
  end

  execute "Extracting S3 Syncer" do
    user "www-data"
    cwd node['s3-syncer']['path']
    command "tar xf syncer.tar.gz --strip 1"
  end

  execute "Installing S3 Syncer" do
    user "www-data"
    cwd node['s3-syncer']['path']
    command "`which php` composer-AWS_S3.phar --no-interaction install --prefer-source --optimize-autoloader"
  end

  cron "satis run in cron" do
    minute "*/30"
    command "cd #{deploy["deploy_to"]}/current/ && sh update-dist.sh"
    user "www-data"
  end

end
