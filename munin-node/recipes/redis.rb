package "libio-all-perl"

directory "/opt" do
  owner  "root"
  group  "root"
  mode   "0755"
  action :create
end

cookbook_file "/opt/redis-munin.pl" do
  source "redis-munin.pl"
  mode   "0755"
end

munin_plugins = ["redis_connected_clients", "redis_per_sec", "redis_used_memory"]

munin_plugins.each do |plugin|
  link "/etc/munin/plugins/#{plugin}" do
    to "/opt/redis-munin.pl"
  end
end
