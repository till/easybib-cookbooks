package "gearman-job-server"

template "/etc/default/gearman-server" do
  mode "0755"
  source "gearman-server.erb"
end
