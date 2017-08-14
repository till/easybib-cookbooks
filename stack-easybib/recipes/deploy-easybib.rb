get_apps_to_deploy.each do |application, deploy|
  case application
  when 'easybib'
    unless allow_deploy(application, 'easybib', %w(nginxphpapp))
      Chef::Log.info("stack-easybib::deploy-easybib - #{application} skipped")
      next
    end

  else
    Chef::Log.info("stack-easybib::deploy-easybib - #{application} skipped")
    next
  end

  Chef::Log.info("deploy::#{application} - Deployment started as user: #{deploy[:user]} and #{deploy[:group]}")

  easybib_deploy application do
    deploy_data deploy
  end

  # clean up old config before migration
  file '/etc/nginx/sites-enabled/easybib.com.conf' do
    action :delete
    ignore_failure true
  end

  easybib_nginx application do
    access_log node['nginx-app']['access_log']
    cookbook 'stack-easybib'
    config_template 'easybib.com.conf.erb'
    notifies :reload, 'service[nginx]', :delayed
    notifies node['php-fpm']['restart-action'], 'service[php-fpm]', :delayed
  end
end
