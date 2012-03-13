template "/etc/init.d/gearmand" do
  mode   "0755"
  source "gearmand.initd.erb"
  variables(
    :prefix => node[:gearmand][:prefix],
    :user   => node[:gearmand][:user]
  )
end

service "gearmand" do
  supports [:start, :stop, :restart, :status]
  action :nothing
end
