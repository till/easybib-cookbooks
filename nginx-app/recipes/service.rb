# Nginx installs an Upstart configuration by default. If this file
# doesn't exist, Ubuntu will fall-back to prehistoric init-system.
file '/etc/init/nginx.conf' do
  action :delete
end

service 'nginx' do
  supports :status => true, :restart => true, :reload => true
end
