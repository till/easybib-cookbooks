include_recipe 'nginx-app::server'
include_recipe 'supervisor'

node['vagrant']['applications'].each do |app_name, app_config|

  default_router = if app_config.attribute?('default_router')
                     app_config['default_router']
                   else
                     'index.php'
                   end

  template = 'default-web-nginx.conf.erb'

  domain_name        = app_config['domain_name']
  doc_root_location  = app_config['doc_root_location']
  app_dir            = app_config['app_root_location']

  easybib_nginx app_name do
    cookbook 'stack-cmbm'
    config_template template
    deploy_dir doc_root_location
    default_router default_router
    domain_name domain_name
    notifies :reload, 'service[nginx]', :delayed
  end

  easybib_envconfig app_name

  supervisor_service 'puma_supervisor' do
    action [:enable, :restart]
    autostart true
    command "puma -C #{app_dir}/config/puma.rb /vagrant_cmbm/config.ru"
    numprocs 1
    numprocs_start 0
    priority 999
    autostart true
    autorestart true
    startsecs 0
    startretries 3
    stopsignal 'TERM'
    stopwaitsecs 10
    user 'vagrant'
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
