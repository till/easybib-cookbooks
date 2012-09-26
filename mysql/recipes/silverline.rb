include_recipe "mysql::service"

template "/etc/init.d/mysql" do
  source "mysql.init.erb"
  mode "0755"
  notifies :restart, resources( :service => "mysql")
end

template "/etc/init/mysql.conf" do
  source "mysql.conf.erb"
  mode "0644"
  notifies :restart, resources( :service => "mysql")
end
