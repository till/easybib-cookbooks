service_provider = if Chef::VersionConstraint.new('>= 15.04').include?(node['platform_version'])
                     Chef::Provider::Service::Systemd
                   elsif Chef::VersionConstraint.new('>= 12.04').include?(node['platform_version'])
                     Chef::Provider::Service::Upstart
                   else
                     service_provider = nil
                   end

name = 'gearman-job-server'

service name do
  action :nothing
  provider service_provider
end

execute 'systemctl daemon-reload' do
  action :nothing
  only_if do
    service_provider == Chef::Provider::Service::Systemd
  end
end

cookbook_file "/etc/init/#{name}.conf" do
  action :create_if_missing
  source 'upstart.conf'
  owner 'root'
  group 'root'
  mode 00644
end

cookbook_file "/etc/init/#{name}.override" do
  source 'upstart.conf'
  owner 'root'
  group 'root'
  mode 00644
end

systemd_override = "/etc/systemd/system/#{name}.service.d"

directory systemd_override do
  owner 'root'
  group 'root'
  recursive true
end

cookbook_file "#{systemd_override}/override.conf" do
  source 'systemd.service'
  owner 'root'
  group 'root'
  mode 00644
  notifies :run, 'execute[systemctl daemon-reload]', :immediate
end
