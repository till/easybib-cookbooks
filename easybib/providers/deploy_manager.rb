action :deploy do
  apps = new_resource.apps
  deployments = new_resource.deployments

  did_we_deploy = false

  debug_log("#{new_resource.stack} (OpsWorks Stack)")

  if apps.empty?
    debug_log('No apps configured')
  elsif deployments.empty?
    debug_log('No deployments')
  else
    debug_log('Apps & deployments')
    apps.each do |app_name, app_data|
      raise "'layer' missing for '#{app_name}'" unless app_data.key?('layer')
      raise "'nginx' missing for '#{app_name}'" unless app_data.key?('nginx')

      did_we_deploy = run_deploys(deployments, app_name, app_data)
    end
  end

  debug_log("Notify? - #{did_we_deploy}")
  new_resource.updated_by_last_action(did_we_deploy)
end

# We'll log info because OpsWorks eats "debug"
def debug_log(msg)
  Chef::Log.info("easybib_deploy_manager: #{msg}")
end

# Hash: deployments
# String: app_name
# Hash: app_data
def run_deploys(deployments, app_name, app_data)
  did_we_deploy = false

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

    easybib_nginx application do
      config_template config_template
      domain_name deploy['domains'].join(' ')
      doc_root deploy['document_root']
      htpasswd "#{deploy['deploy_to']}/current/htpasswd"
      notifies :reload, 'service[nginx]', :delayed
      notifies node['easybib-deploy']['php-fpm']['restart-action'], 'service[php-fpm]', :delayed
    end
  end

  did_we_deploy
end
