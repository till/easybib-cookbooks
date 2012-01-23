include_recipe "silverline::add_repo"

package "librato-silverline"

template "/etc/load_manager/lmd.conf" do
  source "lmd.conf.erb"
  mode "0600"
end
