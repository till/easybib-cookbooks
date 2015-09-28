include_recipe 'nginx-app::ppa'
include_recipe 'nginx-app::service'

ohai 'reload_passwd' do
  action :nothing
  plugin 'passwd'
end

package node['nginx-app']['package-name'] do
  notifies :reload, 'ohai[reload_passwd]', :immediately
  notifies :enable, 'service[nginx]'
  notifies :start, 'service[nginx]'
end

# Nginx installs an Upstart configuration by default. If this file
# doesn't exist, Ubuntu will fall-back to prehistoric init-system.
file '/etc/init/nginx.conf' do
  action :delete
end

nginx_app_config 'nginx-app: nginx.conf'
