require 'resolv'

sites = "/etc/nginx/sites-enabled"

execute "remove default vhost" do
  command "rm #{sites}/default"
  not_if  do !File.exist?("#{sites}/default") end
end

template "#{sites}/membase.conf" do
  source "membase.conf.erb"
  variables({
    :ip => node[:instance][:ip]
  })
end
