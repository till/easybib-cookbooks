template "/etc/init.d/#{node['gearmand']['name']}" do
  mode "0755"
  source "gearmand.initd.erb"
  variables(
    :prefix => "#{node['gearmand']['prefix']}/#{node['gearmand']['source']['version']}",
    :name => node['gearmand']['name'],
    :user => node['gearmand']['user']
  )
end

service node['gearmand']['name'] do
  supports       [:start, :stop, :restart, :status, :reload]
  action         :nothing
  reload_command "/etc/init.d/#{node['gearmand']['name']} force-reload"
end
