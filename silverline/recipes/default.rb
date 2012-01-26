include_recipe "silverline::addrepo"

package "librato-silverline"

service "silverline" do
  case node[:platform]
  when "ubuntu"
    if node[:platform_version].to_f >= 9.10
      provider Chef::Provider::Service::Upstart
    end
  end
  supports :restart => true, :start => true
  action [:start]
end

template "/etc/load_manager/lmd.conf" do
  source "lmd.conf.erb"
  mode "0600"
  notifies :restart, resources( :service => "silverline")
end
