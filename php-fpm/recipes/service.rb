if node['php']['ppa']['package_prefix'].include?('easybib')
  service_name = 'php-fpm'
else
  service_name = "#{node['php']['ppa']['package_prefix']}-fpm"
end

service 'php-fpm' do
  action :nothing
  service_name service_name
  supports [:start, :stop, :status, :reload, :restart]
end
