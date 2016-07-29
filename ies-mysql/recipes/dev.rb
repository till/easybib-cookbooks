# Grant root access from *!
# Obviously not a good idea in production.

mysql_version = node['ies-mysql']['version']

grant_file = if mysql_version == '5.6'
               'grant.sql'
             else
               'grant57.sql'
             end

cookbook_file "/tmp/#{grant_file}" do
  source grant_file
  mode '0600'
  not_if { is_aws(node) }
end

server_config = node['ies-mysql']['server-config']

mysql_command = "mysql -u #{server_config['user']}"
mysql_command += " -p#{server_config['password']}" unless server_config['password'].empty?
mysql_command += ' -h 127.0.0.1' if mysql_version == '5.6'
mysql_command += " < /tmp/#{grant_file}"

execute 'open mysql to the world' do
  command mysql_command
  not_if { is_aws(node) }
end
