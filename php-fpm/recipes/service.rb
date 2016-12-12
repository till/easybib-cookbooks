service_name = if node['php']['ppa']['package_prefix'].include?('easybib')
                 'php-fpm'
               else
                 "#{node['php']['ppa']['package_prefix']}-fpm"
               end

template '/etc/init.d/php-fpm' do
  mode   '0755'
  source 'init.d.php-fpm.erb'
  owner  node['php-fpm']['user']
  group  node['php-fpm']['group']
  only_if do
    node['php']['ppa']['package_prefix'] == 'php5-easybib'
  end
end

service 'php-fpm' do
  action :nothing
  unless node['php']['ppa']['package_prefix'].include?('easybib')
    if node['platform_version'] == '16.04'
      provider Chef::Provider::Service::Systemd
    else
      provider Chef::Provider::Service::Upstart
    end
  end
  service_name service_name
  supports [:start, :stop, :status, :reload, :restart]
end
