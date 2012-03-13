include_recipe "gearmand::service"

template "/etc/default/gearmand" do
  mode   "0644"
  source "gearmand.default.erb"
  variables(
    :port => node[:gearmand][:port],
    :log  => node[:gearmand][:log]
  )
  notifies :restart, resources( :service => "gearmand")
end
