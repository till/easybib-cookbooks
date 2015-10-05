service 'nginx-upstart' do
  service_name 'nginx'
  provider Chef::Provider::Service::Upstart
  supports :status => true, :restart => true, :reload => true
end

service 'nginx' do
  action :nothing
  provider Chef::Provider::Service::Init::Debian
  supports :status => true, :restart => true, :reload => true
end

# Nginx installs an Upstart configuration by default. We want to
# use the old sys-v-init system. In order to fall-back to the old
# system, we have to stop, delete the upstart config and restart
# the nginx service.
upstart_config = '/etc/init/nginx'
file upstart_config do
  action :nothing
  notifies :stop, 'service[nginx-upstart]', :immediately
  only_if { ::File.exist?(upstart_config) }
end
file upstart_config do
  action :delete
  notifies :restart, 'service[nginx]', :immediately
  only_if { ::File.exist?(upstart_config) }
end
