node['deploy'].each do |application, deploy|
  case application
  when 'edu'
    next unless allow_deploy(application, 'edu')
  when 'webeval'
    next unless allow_deploy(application, 'webeval')
  else
    Chef::Log.info("stack-easybib::deploy-silexapps - #{application} skipped")
    next
  end

  Chef::Log.info("deploy::#{application} - Deployment started as user: #{deploy[:user]} and #{deploy[:group]}")

  easybib_deploy application do
    deploy_data deploy
  end

  easybib_nginx application do
    access_log node['nginx-app']['access_log']
    cookbook 'stack-easybib'
    config_template 'silex.conf.erb'
    notifies :reload, 'service[nginx]', :delayed
    notifies node['php-fpm']['restart-action'], 'service[php-fpm]', :delayed
  end
end
