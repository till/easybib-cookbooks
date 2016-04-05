
cronscript = "#{node['php-fpm']['prefix']}/bin/phpfpm-cloudwatch.sh"

include_recipe 'awscli'

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
end

cron_d 'phpfpm-cloudwatch' do
  action :create
  minute '*'
  user 'www-data'
  command cronscript
end
