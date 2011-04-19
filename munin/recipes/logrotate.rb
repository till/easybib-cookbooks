template "/etc/logrotate.d/munin" do
  source "logrotate.erb"
  owner  "root"
  group  "root"
end
