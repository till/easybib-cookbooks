include_recipe 'awscli' if node['php-fpm']['cloudwatch']

cronscript = "#{node['php-fpm']['prefix']}/bin/phpfpm-cloudwatch.sh"

cron_d 'phpfpm-cloudwatch' do
  action :nothing
  minute '*'
  user 'www-data'
  command cronscript
  path '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'
end

template cronscript do
  source 'cloudwatch.sh.erb'
  mode   '0755'
  owner  'root'
  group  'root'
  variables(
    'instancename' => get_record_name.gsub(/\.|\W/, '_'),
    'stackname' => get_normalized_cluster_name.gsub(/\.|\W/, '_'),
    'region' => node['opsworks']['instance']['region']
  )
  notifies :create, 'cron_d[phpfpm-cloudwatch]', :immediately
  only_if { node['php-fpm']['cloudwatch'] }
end
