include_recipe 'php-fpm::service'
include_recipe 'nginx-app::service'

node['deploy'].each do |application, deploy|
  case application
  when 'opsworks_sample'
    next unless allow_deploy(application, 'opsworks_sample', 'nginxphpapp')
  else
    Chef::Log.info("deploy::opsworks-sample - #{application} skipped")
    next
  end

  Chef::Log.info("deploy::#{application} - Deployment started.")
  Chef::Log.info("deploy::#{application} - Deploying as user: #{deploy['user']} and #{deploy['group']}")

  easybib_deploy application do
    deploy_data deploy
    app application
  end

  config_template = 'silex.conf.erb'

  easybib_nginx application do
    config_template config_template
    domain_name deploy['domains'].join(' ')
    doc_root deploy['document_root']
    nginx_local_conf "#{::EasyBib::Config.get_appdata(node, application, 'app_dir')}/deploy/nginx.conf"
    listen_opts nil
    notifies :reload, 'service[nginx]', :delayed
    notifies node['easybib-deploy']['php-fpm']['restart-action'], 'service[php-fpm]', :delayed
  end

end
