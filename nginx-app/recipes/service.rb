service 'nginx' do
  provider Chef::Provider::Service::Upstart
  supports :status => true, :restart => true, :reload => true
end

execute 'configtest' do
  command '/usr/sbin/nginx -t'
  action :nothing
end
