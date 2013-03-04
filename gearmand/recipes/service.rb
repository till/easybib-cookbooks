service node[:gearmand][:name] do
  supports       [:start, :stop, :restart, :status, :reload]
  action         :nothing
  reload_command "force-reload"
end
