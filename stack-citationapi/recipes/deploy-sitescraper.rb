node['deploy'].each do |application, deploy|

  case application
  when 'sitescraper'
    next unless allow_deploy(application, 'sitescraper')
  else
    Chef::Log.info("stack-citationapi::deploy-sitescraper - #{application} (in stack-citationapi) skipped")
    next
  end

  Chef::Log.info("deploy::#{application} - Deployment started.")
  Chef::Log.info("deploy::#{application} - Deploying as user: #{deploy[:user]} and #{deploy[:group]}")

  easybib_deploy application do
    deploy_data deploy
    app application
  end

  easybib_nginx application do
    cookbook 'stack-citationapi'
    config_template 'sitescraper.conf.erb'
    notifies :reload, 'service[nginx]', :delayed
    notifies node['easybib-deploy']['php-fpm']['restart-action'], 'service[php-fpm]', :delayed
  end

end
