service_provider = if Chef::VersionConstraint.new('>= 15.04').include?(node['platform_version'])
                     Chef::Provider::Service::Systemd
                   elsif Chef::VersionConstraint.new('>= 12.04').include?(node['platform_version'])
                     Chef::Provider::Service::Upstart
                   else
                     service_provider = nil
                   end

service 'gearman-job-server' do
  action :nothing
  provider service_provider
end

execute 'systemctl daemon-reload' do
  action :nothing
  only_if do
    service_provider == Chef::Provider::Service::Systemd
  end
end

cookbook_file '/etc/init/gearman-job-server.conf' do
  source 'upstart.conf'
  owner 'root'
  group 'root'
  mode 00644
end

cookbook_file '/lib/systemd/system/gearman-job-server.service' do
  source 'systemd.service'
  owner 'root'
  group 'root'
  mode 00644
  notifies :run, 'execute[systemctl daemon-reload]', :immediate
end
