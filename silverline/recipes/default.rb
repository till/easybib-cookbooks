include_recipe "silverline::addrepo"

service "silverline" do
  start_command "start silverline"
  stop_command "stop silverline"
  restart_command "restart silverline"
  supports :restart, :start, :stop
end

package "librato-silverline"

template "/etc/load_manager/lmd.conf" do
  source "lmd.conf.erb"
  mode "0600"
  notifies :restart, resource( :service => "silverline)
end
