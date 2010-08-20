package "gearman-job-server"
package "php5-cli"

template "/etc/default/gearman-server" do
  mode "0755"
  source "gearman-server.erb"
end