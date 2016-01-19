include_recipe 'nginx-app::ppa'
include_recipe 'nginx-app::service'
include_recipe 'nginx-app::logs'

ohai 'reload_passwd' do
  action :nothing
  plugin 'passwd'
end

package node['nginx-app']['package-name'] do
  notifies :reload, 'ohai[reload_passwd]', :immediately
  notifies :enable, 'service[nginx]'
  notifies :start, 'service[nginx]'
end

nginx_app_config 'nginx-app: nginx.conf'

# Patch /etc/logrotate.d/nginx so rotating the logs doesn't fail.
# See: https://bugs.launchpad.net/nginx/+bug/1450770
template('/etc/logrotate.d/nginx') { source 'nginx.logrotate.erb' }
