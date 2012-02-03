include_recipe "mysql::service"

template "/etc/mysql/debian-start" do
  source "debian-start.erb"
  mode "0755"
  notifies :restart, resources( :service => "mysql")
end
