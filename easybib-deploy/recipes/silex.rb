include_recipe 'php-fpm::service'
include_recipe 'nginx-app::service'

node['deploy'].each do |application, deploy|

  if application == 'api'
    next unless allow_deploy(application, 'api', 'nginxphpapp')
  end

  if application == 'discover_api'
    next unless allow_deploy(application, 'discover_api', 'nginxphpapp')
  end

  if application == 'featureflags'
    next unless allow_deploy(application, 'featureflags', 'nginxphpapp')
  end

  if application == 'id'
    next unless allow_deploy(application, 'id', 'nginxphpapp')
  end

  if application == 'scholar'
    next unless allow_deploy(application, 'scholar', 'nginxphpapp')
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
    notifies :restart, 'service[nginx]', :delayed
  end

  service 'php-fpm' do
    action :reload
  end

end
