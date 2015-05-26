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

service 'haproxy' do
  action [:enable, :start]
end

execute "echo 'checking if HAProxy is not running - if so start it'" do
  not_if 'pgrep haproxy'
  notifies :start, 'service[haproxy]'
end

include_recipe 'haproxy::monit'
