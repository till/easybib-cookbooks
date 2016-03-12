action :deploy do
  configured_apps = new_resource.apps
  deployments = new_resource.deployments

  did_we_deploy = false

  debug_log("#{new_resource.stack} (OpsWorks Stack)")

  configured_apps.each do |app_name, app_data|

    raise "'layer' missing" unless app_data.key?('layer')
    raise "'nginx' missing" unless app_data.key?('nginx')

    deployments.each do |application, deploy|

      if application != app_name
        debug_log("#{application} skipped")
        next
      end

      layer_name = app_data['layer']
      next unless allow_deploy(application, app_name, layer_name)

      debug_log('Deployment started')
      debug_log("Deploying as user: #{deploy['user']} and #{deploy['group']}")

      easybib_deploy application do
        deploy_data deploy
        app application
      end

      did_we_deploy = true

      config_template = app_data['nginx']
      next if config_template.nil? # no nginx

      app_dir = get_appdata(node, application, 'app_dir')

      easybib_nginx application do
        config_template config_template
        domain_name deploy['domains'].join(' ')
        doc_root deploy['document_root']
        htpasswd "#{deploy['deploy_to']}/current/htpasswd"
        nginx_local_conf "#{app_dir}/deploy/nginx.conf"
        notifies :reload, 'service[nginx]', :delayed
        notifies node['easybib-deploy']['php-fpm']['restart-action'], 'service[php-fpm]', :delayed
      end
    end
  end

  new_resource.updated_by_last_action(did_we_deploy)
end

# We'll log info because OpsWorks eats "debug"
def debug_log(msg)
  Chef::Log.info("easybib_deploy_manager: #{msg}")
end
