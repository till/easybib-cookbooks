# Nginx installs an Upstart configuration by default. If this file
# doesn't exist, Ubuntu will fall-back to prehistoric init-system.
service 'nginx-upstart' do
  action :stop
  provider Chef::Provider::Service::Upstart
  only_if do
    ::File.exists?('/etc/init/nginx.conf')
  end
end

file '/etc/init/nginx.conf' do
  action :delete
  ignore_failure true
end

service 'nginx' do
  provider Chef::Provider::Service::Init::Debian
  supports :status => true, :restart => true, :reload => true
end
