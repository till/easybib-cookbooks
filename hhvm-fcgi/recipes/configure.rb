config = node['hhvm-fcgi']['config']

config.each do |config_type, settings|

  next if config_type == 'hhvm'

  template get_complete_path(settings['file']) do
    mode     '0755'
    cookbook 'php-fpm'
    source   'php.ini.erb'
    variables(
      :hhvm => settings['hhvm'],
      :hhvm_port => node['hhvm-fcgi']['listen']['port'],
      :enable_dl => settings['enable_dl'],
      :memory_limit => settings['memory_limit'],
      :display_errors => settings['display_errors'],
      :max_execution_time => settings['max_execution_time'],
      :logfile => node['hhvm-fcgi']['logfile'],
      :tmpdir => node['hhvm-fcgi']['tmpdir'],
      :prefix => node['hhvm-fcgi']['prefix']
    )
    owner node['hhvm-fcgi']['user']
    group node['hhvm-fcgi']['group']
    notifies :restart, 'service[hhvm]', :delayed
  end
end

template get_complete_path(config['hhvm']['file']) do
  mode '0755'
  source 'config.hdf.erb'
  variables(
    :display_errors => config['hhvm']['display_errors']
  )
  owner node['hhvm-fcgi']['user']
  group node['hhvm-fcgi']['group']
end

template '/etc/logrotate.d/hhvm' do
  cookbook 'php-fpm'
  source 'logrotate.erb'
  variables(
    :logfile => node['hhvm-fcgi']['logfile']
  )
  mode '0644'
  owner 'root'
  group 'root'
  notifies :enable, 'service[hhvm]'
  notifies :start, 'service[hhvm]'
end

template '/etc/monit/conf.d/hhvm.monitrc' do
  mode 0644
  source 'hhvm.monitrc.erb'
  variables(
    :pid_file => node['hhvm-fcgi']['pid_file'],
    :service_name => node['hhvm-fcgi']['service_name']
  )
  only_if do
    ::EasyBib.is_aws(node)
  end
end
