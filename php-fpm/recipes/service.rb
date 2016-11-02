if node['php']['ppa']['package_prefix'].include?('easybib')
  service_name = 'php-fpm'
  service_provider = Chef::Provider::Service::Init
else
  service_name = "#{node['php']['ppa']['package_prefix']}-fpm"
  service_provider = if node['platform_version'] == '16.04'
                       Chef::Provider::Service::Systemd
                     else
                       Chef::Provider::Service::Upstart
                     end
end

service 'php-fpm' do
  action :nothing
  provider service_provider
  service_name service_name
  supports [:start, :stop, :status, :reload, :restart]
end
