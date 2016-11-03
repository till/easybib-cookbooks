service_name = if node['php']['ppa']['package_prefix'].include?('easybib')
                 'php-fpm'
               else
                 "#{node['php']['ppa']['package_prefix']}-fpm"
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
