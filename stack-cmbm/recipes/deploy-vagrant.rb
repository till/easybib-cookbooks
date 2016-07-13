Chef::Log.info('# POOP START #############################################')
node['vagrant']['applications'].each do |app_name, app_data|
  next unless %w(cmbm).include?(app_name)

  default_router = if app_data.attribute?('default_router')
                     app_data['default_router']
                   else
                     'index.php'
                   end

  template = 'default-web-nginx.conf.erb'

  domain_name        = app_data['domain_name']
  doc_root_location  = app_data['doc_root_location']
  app_dir            = app_data['app_root_location']
  tmp_dir            = "#{app_dir}/tmp"
  gem_home           = node.fetch(app_name, {}).fetch('env', {}).fetch('gem', {}).fetch('home', '')

  easybib_nginx app_name do
    cookbook 'stack-cmbm'
    config_template template
    deploy_dir doc_root_location
    default_router default_router
    domain_name domain_name
    notifies :reload, 'service[nginx]', :delayed
  end

  directory tmp_dir do
    mode '0777'
    action :create
  end

  supervisor_service "#{app_name}_supervisor" do
    action [:enable, :restart]
    autostart true
    command "bash -l -c 'cd #{app_dir}; source .deploy_configuration.sh; #{gem_home}/bin/puma -C config/puma.rb config.ru'"
    numprocs 1
    numprocs_start 0
    priority 999
    autostart true
    autorestart true
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

  Chef::Log.info('# POOP stuff #############################################')

end
Chef::Log.info('# POOP END ###############################################')
