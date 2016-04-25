Chef::Application.fatal!('This recipe is vagrant only!') if is_aws

include_recipe 'nginx-app::server'
include_recipe 'supervisor'

user = if is_aws
         'root'
       else
         'vagrant'
       end

home = if is_aws
         '/root'
       else
         "/home/#{user}"
       end

rbenv_home = "#{home}/.rbenv"
rbenv_paths = [
  %(#{rbenv_home}/bin),
  %(#{rbenv_home}/shims),
].join(':')
path = "#{rbenv_paths}:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

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

  ruby_cmbm = node.fetch('ruby', {}).fetch('rubies', {}).fetch('cmbm', '')
  execute 'install bundler' do
    command "su #{user} -l -c '#{home}/.rbenv/versions/#{ruby_cmbm}/bin/gem install bundler'"
    environment ({"PATH" => path, "HOME" => home, "USER" => user})
  end

  execute 'install gem dependencies' do
    command "su #{user} -l -c 'cd #{app_dir} && #{home}/.rbenv/versions/#{ruby_cmbm}/bin/bundle install'"
    environment ({"PATH" => path, "HOME" => home, "USER" => user})
  end

  execute 'setup app' do
    cwd app_dir
    user user
    environment ({"PATH" => path, "HOME" => home, "USER" => user})
    command "export RBENV_VERSION=#{ruby_cmbm} && #{home}/.rbenv/versions/#{ruby_cmbm}/bin/bundle exec rake db:setup"
  end

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
    command "#{rbenv_home}/shims/puma -C #{app_dir}/config/puma.rb /#{app_dir}/config.ru"
    environment ({"PATH" => path, "RBENV_VERSION" => ruby_cmbm})
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
end
