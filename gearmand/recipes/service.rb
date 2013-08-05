service node['gearmand']['name'] do
  supports       [:start, :stop, :restart, :status, :reload]
  action         :nothing
  reload_command "/etc/init.d/#{node['gearmand']['name']} force-reload"
end
