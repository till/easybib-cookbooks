include_recipe "silverline::addrepo"
include_recipe "silverline::service"

package "librato-silverline"

# hack, apparently we need to start it first
service "silverline" do
  action :start
end

template "/etc/load_manager/lmd.conf" do
  source "lmd.conf.erb"
  mode "0600"
  notifies :restart, resources( :service => "silverline")
end
