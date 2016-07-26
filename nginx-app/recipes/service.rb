nginx_service_provider = if node['platform_version'] == '16.04'
                            Chef::Provider::Service::Systemd
                          else
                            Chef::Provider::Service::Upstart
                          end

service 'nginx' do
  provider nginx_service_provider
  supports :status => true, :restart => true, :reload => true
end

execute 'configtest' do
  command '/usr/sbin/nginx -t'
  action :nothing
end
