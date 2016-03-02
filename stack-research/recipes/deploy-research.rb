node['deploy'].each do |application, deploy|

  case application
  when 'research_app'
    next unless allow_deploy(application, 'research_app', 'research_app')
  else
    Chef::Log.info("deploy::#{application} - stack-research skipped")
    next
  end

  Chef::Log.info("deploy::#{application} - Deployment started.}")
  Chef::Log.info("deploy::#{application} - Deploying as user: #{deploy[:user]} and #{deploy[:group]}")

  easybib_deploy application do
    deploy_data deploy
    app application
    notifies node['easybib-deploy']['php-fpm']['restart-action'], 'service[php-fpm]'
  end

  easybib_nginx application do
    cookbook 'stack-research'
    config_template 'research-app.conf.erb'
    access_log      'off'
    notifies :reload, 'service[nginx]', :delayed
    notifies node['easybib-deploy']['php-fpm']['restart-action'], 'service[php-fpm]', :delayed
  end

end
