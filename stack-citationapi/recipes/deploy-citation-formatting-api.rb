include_recipe 'stack-citationapi::role-phpapp'
include_recipe 'redis::default'
include_recipe 'stack-citationapi::deploy-publicapi'

node['deploy'].each do |application, deploy|
  case application
  when 'easybib_api'
    next unless allow_deploy(application, 'easybib_api', 'bibapi')
  else
    Chef::Log.info("deploy::internal-api - #{application} (in stack-citationapi) skipped")
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
    config_template 'formatting-api.conf.erb'
    access_log      'off'
    notifies :reload, 'service[nginx]', :delayed
    notifies node['easybib-deploy']['php-fpm']['restart-action'], 'service[php-fpm]', :delayed
  end

end
