include_recipe 'tideways::service'
include_recipe 'php-fpm::service'

if is_aws
  hostname = "#{node['opsworks']['instance']['hostname']}.#{get_normalized_cluster_name}"
  environment = if hostname.index('playground')
                  'staging'
                else
                  'production'
                end
else
  hostname = node['fqdn']
  environment = 'development'
end

template '/etc/default/tideways-daemon' do
  source 'tideways-daemon.erb'
  mode 0644
  variables(
    :environment => environment,
    :hostname => hostname
  )
  notifies :restart, 'service[tideways-daemon]'
end

template "#{node['php-fpm']['prefix']}/etc/php/tideways.ini" do
  source 'tideways.ini.erb'
  mode 0644
  notifies :reload, 'service[php-fpm]', :delayed
end
