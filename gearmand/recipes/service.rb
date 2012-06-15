service node[:gearmand][:name] do
  supports [:start, :stop, :restart, :status]
  action :nothing
end
