service 'nginx' do
  provider Chef::Provider::Service::Init::Debian
  supports :status => true, :restart => true, :reload => true
end

# Nginx installs an Upstart configuration by default. If this file
# doesn't exist, Ubuntu will fall-back to prehistoric init-system.
service 'nginx-upstart' do
  service_name 'nginx'
  action :stop
  provider Chef::Provider::Service::Upstart
  notifies :restart, 'service[nginx]'
  only_if do
    ::File.exist?('/etc/init/nginx.conf')
  end
end

file '/etc/init/nginx.conf' do
  action :delete
  ignore_failure true
end
