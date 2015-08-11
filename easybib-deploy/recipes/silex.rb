include_recipe 'php-fpm::service'
include_recipe 'nginx-app::service'

node['deploy'].each do |application, deploy|
  listen_opts = nil
  case application
  when 'api'
    listen_opts = 'default_server'
    next unless allow_deploy(application, 'api', 'nginxphpapp')
  when 'discover_api'
    next unless allow_deploy(application, 'discover_api', 'nginxphpapp')
  when 'featureflags'
    next unless allow_deploy(application, 'featureflags', 'nginxphpapp')
  when 'scholar_admin'
    next unless allow_deploy(application, 'scholar_admin', 'nginxphpapp')
  when 'id'
    next unless allow_deploy(application, 'id', 'nginxphpapp')
  else
    Chef::Log.info("deploy::silex - #{application} skipped")
    next
  end

  Chef::Log.info("deploy::#{application} - Deployment started.")
  Chef::Log.info("deploy::#{application} - Deploying as user: #{deploy[:user]} and #{deploy[:group]}")

  easybib_deploy application do
    deploy_data deploy
    app application
  end

  easybib_nginx application do
    config_template 'silex.conf.erb'
    domain_name deploy['domains'].join(' ')
    doc_root deploy['document_root']
    htpasswd "#{deploy['deploy_to']}/current/htpasswd"
    listen_opts listen_opts
    notifies :reload, 'service[nginx]', :delayed
    notifies :reload, 'service[php-fpm]'
  end
end
