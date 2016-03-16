node['deploy'].each do |application, deploy|
  case application
  when 'easybib'
    next unless allow_deploy(application, 'easybib', 'nginxphpapp')

  when 'easybib_api'
    next unless allow_deploy(application, 'easybib_api', 'bibapi')

  when 'gearmanworker'
    next unless allow_deploy(application, 'gearmanworker', 'gearman-worker')

  else
    Chef::Log.info("stack-easybib::deploy-easybib - #{application} skipped")
    next
  end

  Chef::Log.info("deploy::#{application} - Deployment started.")
  Chef::Log.info("deploy::#{application} - Deploying as user: #{deploy[:user]} and #{deploy[:group]}")

  easybib_deploy application do
    deploy_data deploy
    app application
  end

  case application
  when 'gearmanworker'
    include_recipe 'monit::pecl-manager'
    # else
    #   service 'php-fpm' do
    #     action node['easybib-deploy']['php-fpm']['restart-action']
    #   end
  end

  easybib_nginx application do
    cookbook 'stack-easybib'
    config_template 'easybib.com.conf.erb'
    notifies :reload, 'service[nginx]', :delayed
    notifies node['easybib-deploy']['php-fpm']['restart-action'], 'service[php-fpm]', :delayed
  end
end
