package "nginx"

service "nginx" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end

sites = "/etc/nginx/sites-enabled"

execute "remove default vhost" do
  command "rm #{sites}/default"
  not_if  do !File.exist?("#{sites}/default") end
end

template "#{sites}/membase.conf" do
  source "membase.conf.erb"
  variables({
    :ip => node[:scalarium][:instance][:ip]
  })
  notifies :restart, resources(:service => "nginx"), :delayed
end

