# Grant root access from *!
# Obviously not a good idea in production.

cookbook_file "/tmp/grant.sql" do
  source "grant.sql"
  mode "0600"
end

mysql_command = "mysql -u #{node[:percona][:user]}"
if not node[:percona][:password].empty?
  mysql_command += " -p#{node[:percona][:password]}"
end
mysql_command += " < /tmp/grant.sql"

execute "open mysql to the world!!!111one" do
  command mysql_command
end
