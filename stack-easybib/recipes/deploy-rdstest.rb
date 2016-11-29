get_apps_to_deploy.each do |application, deploy|
  case application
  when 'rds_test'
    unless allow_deploy(application, 'rds_test', %w(nginxphpapp))
      Chef::Log.info("stack-easybib::deploy-rdstest - #{application} skipped")
      next
    end
  else
    Chef::Log.info("stack-easybib::deploy-rdstest - #{application} skipped")
    next
  end

  Chef::Log.info("stack-easybib::deploy-rdstest - Deployment started as #{deploy[:user]}:#{deploy[:group]}")

  easybib_deploy application do
    deploy_data deploy
  end

  easybib_nginx application do
    cookbook 'stack-easybib'
    config_template 'silex.conf.erb'
    notifies :reload, 'service[nginx]', :delayed
    notifies node['php-fpm']['restart-action'], 'service[php-fpm]', :delayed
  end
end
