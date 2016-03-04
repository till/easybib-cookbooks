include_recipe 'php-fpm::service'
include_recipe 'nginx-app::service'

node['deploy'].each do |application, deploy|
  listen_opts = nil

  case application
  when 'scholar_admin'
    next unless allow_deploy(application, 'scholar_admin', 'nginxphpapp')
  when 'scholar_realtime'
    if node['haproxy']['websocket_layers'].nil?
      next
    end

    next unless allow_deploy(application, 'scholar_realtime', node['haproxy']['websocket_layers'].keys)
  when 'scholar'
    listen_opts = 'default_server'
    supervisor_role = node['easybib_deploy']['supervisor_role']
    next unless allow_deploy(application, 'scholar', ['nginxphpapp', supervisor_role])
  else
    Chef::Log.info("deploy::scholar - #{application} skipped")
    next
  end

  Chef::Log.info("deploy::#{application} - Deployment started.")
  Chef::Log.info("deploy::#{application} - Deploying as user: #{deploy['user']} and #{deploy['group']}")

  easybib_deploy application do
    deploy_data deploy
    app application
  end

  if application == 'scholar_realtime'
    next
  end

  if application == 'scholar'
    config_template = 'scholar.conf.erb'
  else
    config_template = 'silex.conf.erb'
  end

  easybib_nginx application do
    config_template config_template
    domain_name deploy['domains'].join(' ')
    doc_root deploy['document_root']
    htpasswd "#{deploy['deploy_to']}/current/htpasswd"
    nginx_local_conf "#{::EasyBib::Config.get_appdata(node, application, 'app_dir')}/deploy/nginx.conf"
    listen_opts listen_opts
    notifies :reload, 'service[nginx]', :delayed
    notifies node['easybib-deploy']['php-fpm']['restart-action'], 'service[php-fpm]', :delayed
  end

end
