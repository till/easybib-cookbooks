package "gearman-job-server"

template "/etc/default/gearman-job-server" do
  mode "0755"
  source "gearman-server.erb"
end
