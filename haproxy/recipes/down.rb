directory "/etc/haproxy/errors/" do
  recursive true
  mode "0755"
  action :create
end

node["haproxy"]["errorloc"].each do |code,file|
  cookbook_file "/etc/haproxy/errors/#{file}" do
    source file
    owner "haproxy"
    group "haproxy"
    mode 0644
  end
end
