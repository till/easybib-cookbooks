# Grant root access from *!
# Obviously not a good idea in production.

cookbook_file '/tmp/grant.sql' do
  source 'grant.sql'
  mode '0600'
end

server_config = node['ies-mysql']['server-config']

mysql_command = "mysql -u #{server_config['user']}"
mysql_command += " -p#{server_config['password']}" unless server_config['password'].empty?
mysql_command += ' -h 127.0.0.1'
mysql_command += ' < /tmp/grant.sql'

execute 'open mysql to the world in mysql config' do
  command mysql_command
end
