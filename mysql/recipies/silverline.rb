service "mysql" do
  supports [:restart]
  action :nothing
end

template "/etc/mysql/debian-start" do
  source "debian-start.erb"
  mode "0755"
  notifies :restart, resources( :service => "mysql")
end
