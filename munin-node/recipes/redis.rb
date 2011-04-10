cookbook_file "/opt/redis-munin.pl" do
  source "redis-munin.pl"
  mode   "0755"
end

link "/etc/munin/plugins/redis-munin" do
  to "/opt/redis-munin.pl"
end
