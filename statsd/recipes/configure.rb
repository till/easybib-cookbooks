base = "/etc/statsd"

directory base do
  mode  "0755"
  owner node[:librato][:node][:user]
  group node[:librato][:node][:group]
end

template "#{base}/config.js" do
  source "easybib-config.js.erb"
  mode   "0600"
  owner  node[:librato][:node][:user]
  group  node[:librato][:node][:group]
end
