include_recipe 'nginx-app::server'

cluster_name = get_cluster_name

node['deploy'].each do |application, deploy|
  Chef::Log.info("nginx-app::configure - app: #{application}")

  case application
  when 'easybib'
    nginxphpapp_allowed = allow_deploy(application, 'easybib', 'nginxphpapp')
    unless nginxphpapp_allowed
      Chef::Log.info("deploy::#{application} - skipping easybib, allow_deploy mismatch")
      next
    end

  when 'easybib_api'
    next unless allow_deploy(application, 'easybib_api', 'bibapi')

  else
    Chef::Log.info("deploy::#{application} (in #{cluster_name}) skipped.")
    next
  end

  Chef::Log.info("deploy::#{application} - Deployment started.")
  Chef::Log.info("deploy::#{application} - Deploying as user: #{deploy[:user]} and #{deploy[:group]}")

  easybib_deploy application do
    deploy_data deploy
    app application
  end

  easybib_nginx application do
    config_template 'internal-api.conf.erb'
    domain_name deploy['domains'].join(' ')
    doc_root deploy['document_root']
    access_log      'off'
    notifies :reload, 'service[nginx]', :delayed
    notifies node['easybib-deploy']['php-fpm']['restart-action'], 'service[php-fpm]', :delayed
  end
end
