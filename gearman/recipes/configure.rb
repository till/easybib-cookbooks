include_recipe "gearman::service"

template "/etc/default/gearman-job-server" do
  mode     "0644"
  source   "gearman-server.erb"
  notifies :restart, resources(:service => "gearman-job-server"), :immediately
end
