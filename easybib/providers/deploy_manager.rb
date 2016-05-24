action :deploy do
  applications = new_resource.apps
  deployments = new_resource.deployments

  did_we_deploy = false

  debug_log("#{new_resource.stack} (OpsWorks Stack)")

  if applications.empty?
    debug_log('No apps configured')
  elsif deployments.empty?
    debug_log('No deployments')
  else
    debug_log('Apps & deployments')
    applications.each do |app_name, app_data|
      validate_app_data(app_data)

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

# Run deployments
#
# deployments - Hash, from OpsWorks
# app_name - String
# app_data - Hash
def run_deploys(deployments, app_name, app_data)
  did_we_deploy = false

  deployments.each do |application, deploy|

    if application != app_name
      debug_log("#{application} skipped: #{app_name}")
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

    nginx_config = app_data.fetch('nginx', nil)
    next if nginx_config.nil? # no nginx

    config_template = get_template(nginx_config)
    next if config_template.nil? # no nginx

    config_cookbook = get_cookbook(nginx_config)

    listen_opts = get_additional('listen_opts', app_data)

    easybib_nginx application do
      cookbook config_cookbook
      config_template config_template
      domain_name deploy['domains'].join(' ')
      doc_root deploy['document_root']
      htpasswd "#{deploy['deploy_to']}/current/htpasswd"
      listen_opts listen_opts
      notifies :reload, 'service[nginx]', :delayed
      notifies node['easybib-deploy']['php-fpm']['restart-action'], 'service[php-fpm]', :delayed
    end
  end

  did_we_deploy
end

# Extracts optional "listen_opts" for "easybib_nginx"
#
# data - Hash
#
# Returns a string or nil.
def get_additional(key, data)
  data.fetch('nginx_config', {}).fetch(key, nil)
end

# data - mixed (Hash or String)
#
# Return string
def get_cookbook(data)
  default_cookbook = 'nginx-app'

  if data.is_a?(String)
    return default_cookbook
  end

  data.fetch('cookbook', default_cookbook)
end

# data - mixed (Hash or String)
#
# Returns a string or nil
def get_template(data)
  if data.is_a?(String)
    return data
  end

  data.fetch('conf', nil)
end

def validate_app_data(app_data)
  raise 'Must be a hash!' unless app_data.is_a?(Hash)

  raise "'layer' missing for '#{app_name}'" unless app_data.key?('layer')
  raise "'nginx' missing for '#{app_name}'" unless app_data.key?('nginx')
end
