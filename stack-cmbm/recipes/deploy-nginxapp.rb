include_recipe 'nginx-app::server'
include_recipe 'supervisor'

user = if is_aws
         node.fetch('nginx-app', {}).fetch('user', 'www-data')
       else
         'vagrant'
       end

applications = if is_aws
                 node['deploy']
               else
                 node['vagrant']['applications']
               end

applications.each do |app_name, app_config|

  template = 'default-web-nginx.conf.erb'

  domain_name        = app_config['domain_name']
  doc_root_location  = app_config['doc_root_location']
  app_dir            = app_config['app_root_location']
  app_ruby           = node.fetch('stack-cmbm', {}).fetch('desired_rubies', {}).fetch(app_name, '')
  db_node            = node.fetch('deploy', {}).fetch(app_name, {}).fetch('database', {})
  smtp_node          = node.fetch('postfix', {}).fetch('relay')

  ies_rbenv_deploy 'deploy ruby' do
    rbenv_users [user]
    rubies [app_ruby]
    gems ['bundler']
  end

  if is_aws
    easybib_deploy app_name do
      deploy_data app_config
      app app_name
    end
  else
    easybib_envconfig app_name
  end

  easybib_nginx app_name do
    cookbook 'stack-cmbm'
    config_template template
    deploy_dir doc_root_location
    domain_name domain_name
    notifies :reload, 'service[nginx]', :delayed
  end

  supervisor_service 'puma_supervisor' do
    action [:enable, :restart]
    autostart true
    command "bash -l -c '~/.rbenv/shims/puma -C #{app_dir}/config/puma.rb /#{app_dir}/config.ru'"
    environment(
      # CMBM application configuration
      'RACK_ENV' => node.fetch('stack-cmbm', {}).fetch('environments', {}).fetch(app_name, ''),

      # Rails database configuration
      'DB_DATABASE' => db_node.fetch('name', ''),
      'DB_HOST' => db_node.fetch('address', ''),
      'DB_USER' => db_node.fetch('username', ''),
      'DB_PASS' => db_node.fetch('password', ''),

      # Rails mail-relay configuration
      'SMTP_HOST' => smtp_node.fetch('hostname', ''),
      'SMTP_PORT' => smtp_node.fetch('port', 25),
      'SMTP_USERNAME' => smtp_node.fetch('user', ''),
      'SMTP_PASSWORD' => smtp_node.fetch('pass', '')
    )
    numprocs 1
    numprocs_start 0
    priority 999
    autostart false     # Todo: set to true
    autorestart false   # Todo: set to true
    startsecs 0
    startretries 3
    stopsignal 'TERM'
    stopwaitsecs 10
    user user
    redirect_stderr false
    stdout_logfile 'syslog'
    stdout_logfile_maxbytes '50MB'
    stdout_logfile_backups 10
    stdout_capture_maxbytes '0'
    stdout_events_enabled false
    stderr_logfile 'syslog'
    stderr_logfile_maxbytes '50MB'
    stderr_logfile_backups 10
    stderr_capture_maxbytes '0'
    stderr_events_enabled false
    serverurl 'AUTO'
  end
end
