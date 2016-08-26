include_recipe 'nginx-app::ppa'
include_recipe 'nginx-app::service'

# OHAI7 change
reload_plugin = if Gem::Version.new(::Ohai::VERSION) >= Gem::Version.new('7.0.0')
                  'etc'
                else
                  'passwd'
                end

ohai 'reload_passwd' do
  action :nothing
  plugin reload_plugin
end

package node['nginx-app']['package-name'] do
  notifies :reload, 'ohai[reload_passwd]', :immediately
  notifies :enable, 'service[nginx]'
  notifies :start, 'service[nginx]'
end

nginx_app_config 'nginx-app: nginx.conf'

include_recipe 'nginx-app::rsyslogs'

# Patch /etc/logrotate.d/nginx so rotating the logs doesn't fail.
# See: https://bugs.launchpad.net/nginx/+bug/1450770
template('/etc/logrotate.d/nginx') { source 'nginx.logrotate.erb' }
