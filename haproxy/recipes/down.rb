directory "/etc/haproxy/errors/" do
  recursive true
  mode "0755"
  action :create
end

node["haproxy"]["errorloc"].each do |code, file|
  cookbook_file "/etc/haproxy/errors/#{file}" do
    source file
    owner "haproxy"
    group "haproxy"
    mode 0644
  end
end

template '/etc/haproxy/haproxy.cfg' do
  source 'haproxy.easybib.cfg.erb'
  owner 'root'
  group 'root'
  mode 0644
  notifies :restart, "service[haproxy]"
end
