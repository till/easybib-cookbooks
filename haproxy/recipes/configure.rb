include_recipe 'haproxy::service'

directory '/etc/haproxy/errors/' do
  recursive true
  mode '0755'
  action :create
end

node['haproxy']['errorloc'].each do |code, file|
  cookbook_file "/etc/haproxy/errors/#{file}" do
    source "#{node['haproxy']['templates_directory']}/#{file}"
    owner 'haproxy'
    group 'haproxy'
    mode 0644
  end
end

template '/etc/haproxy/haproxy.cfg' do
  source 'haproxy.easybib.cfg.erb'
  owner 'root'
  group 'root'
  mode 0644
  notifies :reload, 'service[haproxy]'
end

if node['haproxy']['ssl'] == 'off'
  service 'haproxy' do
    action [:enable, :start]
  end
else
  # cert is generated in easybib-deploy::ssl-certificates - we can not notify
  # there because during inital setup of lb haproxy is not there yet, so we
  # subscribe from here.
  certificate = "#{node['ssl-deploy']['directory']}/cert.combined.pem"
  service 'haproxy' do
    action [:enable, :start]
    subscribes :reload, "template[#{certificate}]"
  end
end

execute "echo 'checking if HAProxy is not running - if so start it'" do
  not_if 'pgrep haproxy'
  notifies :start, 'service[haproxy]'
end

include_recipe 'haproxy::monit'
