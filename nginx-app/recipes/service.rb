service 'nginx' do
  supports :status => true, :restart => true, :reload => true
  provider Chef::Provider::Service::Upstart
  action :nothing
end
