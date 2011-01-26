package "munin-node"

munin_plugins = %w[ nginx_status nginx_requests ]

ip_munin = node["scalarium"]["roles"]["monitoring_master"]["instances"]["darth-vader"]["private_dns_name"]
ip_munin = ip_munin.gsub(".", "\.")

template "/etc/munin/munin-node.conf" do
  source "munin-node.erb"
  variables(
    :ip_munin => ip_munin
  )
end

munin_plugins.each { |plugin|
  link "/etc/munin/plugins/#{plugin}"
    to "/usr/share/munin/plugins/#{plugin}"
  end
}

# php_fpm plugins
# clone from github
# symlink
