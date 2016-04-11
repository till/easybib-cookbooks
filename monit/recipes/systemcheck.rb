hostname = 'vagrant-machine'
hostname = get_record_name if is_aws

template '/etc/monit/conf.d/system.monitrc' do
  source 'system.monit.erb'
  mode   '0644'
  owner  'root'
  group  'root'
  variables(
    'hostname' => hostname
  )
  notifies :restart, 'service[monit]'
end
