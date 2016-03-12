action :deploy do
  app_name = new_resource.app
  app_data = new_resource.app_data
  app_dir = new_resource.app_dir
  deployments = new_resource.deployments

  nginx_restart = new_resource.nginx_restart
  php_restart = new_resource.php_restart

  raise "'layer' missing" unless app_data.has_key?('layer')
  raise "'nginx' missing" unless app_data.has_key?('nginx')

  deployments.each do |application, deploy|

    if application != app_name
      Chef::Log.info("EasyBib::AppDeploy - #{application} skipped")
      next
    end

    layer_name = app_data['layer']
    next unless allow_deploy(application, app_name, layer_name)

    Chef::Log.info('EasyBib::AppDeploy - Deployment started.')
    Chef::Log.info("EasyBib::AppDeploy - Deploying as user: #{deploy['user']} and #{deploy['group']}")

    easybib_deploy application do
      deploy_data deploy
      app application
    end

    config_template = app_data['nginx']
    next if config_template.nil? # no nginx

    app_dir = get_appdata(node, application, 'app_dir')

    easybib_nginx application do
      config_template config_template
      domain_name deploy['domains'].join(' ')
      doc_root deploy['document_root']
      htpasswd "#{deploy['deploy_to']}/current/htpasswd"
      nginx_local_conf "#{app_dir}/deploy/nginx.conf"
      notifies nginx_restart, 'service[nginx]', :delayed
      notifies php_restart, 'service[php-fpm]', :delayed
    end
  end
end
