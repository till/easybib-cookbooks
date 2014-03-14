node['deploy'].each do |application, deploy|

  case application
  when 'satis'
    next unless allow_deploy(application, 'satis', 'satis')

  when 'easybib_private_satis'
    next unless allow_deploy(application, 'easybib_private_satis', 'satis')

  when 'satis_s3'
    next unless allow_deploy(application, 'satis_s3', 'satis')

  when 'getcourse_private_satis'
    next unless allow_deploy(application, 'getcourse_private_satis', 'satis')

  else
    Chef::Log.info("deploy::satis - #{application} skipped")
    next
  end

  Chef::Log.info("deploy::satis - Deploying as user: #{deploy["user"]} and #{deploy["group"]} to #{deploy["deploy_to"]}")

  opsworks_deploy_dir do
    user  deploy["user"]
    group deploy["group"]
    path  deploy["deploy_to"]
  end

  easybib_deploy application do
    deploy_data deploy
    app application
  end

  directory '/vol/satis-sync/files/' do
    recursive true
    owner "www-data"
    group "www-data"
    mode  0755
    action :create
  end

  %w(/mnt/satis-output/ /mnt/composer-tmp/).each do |dir|
    directory dir do
      recursive true
      owner "www-data"
      group "www-data"
      mode  0755
      action :create
    end
  end

  cron "satis run update-dist.sh in cron - #{application}" do
    minute "*/30"
    command "cd #{deploy["deploy_to"]}/current/ && sh update-dist.sh"
    user "www-data"
    only_if do
      File.exist?("#{deploy["deploy_to"]}/current/update-dist.sh")
    end
  end

  cron "satis run update-and-pull.sh in cron - #{application}" do
    minute "*/5"
    command "cd #{deploy["deploy_to"]}/current/ && sh update-and-pull.sh"
    user "www-data"
    only_if do
      File.exist?("#{deploy["deploy_to"]}/current/update-and-pull.sh")
    end
  end

  template "/etc/nginx/sites-enabled/#{application}.conf" do
    cookbook "nginx-app"
    source "satis.conf.erb"
    mode   "0755"
    owner  node["nginx-app"]["user"]
    group  node["nginx-app"]["group"]
    variables(
      :doc_root       => "#{deploy['deploy_to']}/current/#{deploy['document_root']}",
      :domain_name    => deploy['domains'].join(' '),
      :htpasswd       => "#{deploy['deploy_to']}/current/htpasswd",
      :access_log     => 'off',
      :nginx_extra    => node["nginx-app"]["extras"]
    )
    notifies :restart, "service[nginx]", :delayed
  end

end
