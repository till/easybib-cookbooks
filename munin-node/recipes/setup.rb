package "munin-node"

munin_plugins = ["nginx_status", "nginx_requests"]

ip_munin = node[:scalarium][:roles]["monitoring-master"][:instances]["darth-vader"]["private_dns_name"]
ip_munin = ip_munin.gsub(".", "\.")

template "/etc/munin/munin-node.conf" do
  source "munin-node.erb"
  variables({
    :ip_munin => ip_munin
  })
end

munin_plugins.each do |plugin|
  link "/etc/munin/plugins/#{plugin}" do
    to "/usr/share/munin/plugins/#{plugin}"
  end
end

# php_fpm plugins
# clone from github
# symlink
