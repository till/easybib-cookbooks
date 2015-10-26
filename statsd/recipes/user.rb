# replace this with postinst
group node['statsd']['group'] do
  action :create
end

user node['statsd']['user'] do
  home '/nonexistent'
  manage_home false
  group node['statsd']['group']
  shell '/bin/false'
  system true
  action :create
end
