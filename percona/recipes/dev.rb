# Grant root access from *!
# Obviously not a good idea in production.

cookbook_file "/tmp/grant.sql" do
  source "grant.sql"
  mode "0600"
end

mysql_command = "mysql -u #{node[:percona][:user]}"
if !node[:percona][:password].empty?
  mysql_command += " -p#{node[:percona][:password]}"
end
mysql_command += " < /tmp/grant.sql"

execute "open mysql to the world in mysql config" do
  command mysql_command
end

cookbook_file "/etc/mysql/my.cnf" do
  source "my.cnf"
  mode "0644"
end

service "mysql" do
  action :restart
end
