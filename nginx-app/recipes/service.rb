# Nginx installs an Upstart configuration by default. If this file
# doesn't exist, Ubuntu will fall-back to prehistoric init-system.
upstart_config = '/etc/init/nginx.conf'
if File.exist?(upstart_config)
  file upstart_config do
    action :delete
  end
else
  Chef::Log.debug('Upstart problem seems resolved, please fix nginx-app::service!')
end

service 'nginx' do
  supports :status => true, :restart => true, :reload => true
end
