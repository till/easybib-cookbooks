include_recipe "gearmand::user"
include_recipe "gearmand::service"


[
  "/var/run/#{node['gearmand']['name']}",
  "#{node["gearmand"]["prefix"]}/#{node['gearmand']['source']['version']}/var/log"
].each do |dir|

  directory dir do
    recursive true
    mode "0755"
    owner node['gearmand']['user']
    group node['gearmand']['user']
  end

end

template "/etc/default/#{node['gearmand']['name']}" do
  mode   "0644"
  source "gearmand.default.erb"
  variables(
    :port => node['gearmand']['port'],
    :log  => node['gearmand']['log']
  )
  notifies :reload, "service[#{node['gearmand']['name']}]"
end
