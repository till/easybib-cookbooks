user = if is_aws
         node['nginx-app']['user']
       else
         'vagrant'
       end

# This configuration file is required by `supervisorctl`. It resembles a CSV with one process configuration per line.
template '/etc/puma.conf' do
  source 'puma.conf.erb'
  user 'root'
  group 'root'
  mode '0755'
  variables(
    :apps => node['puma']['apps'],
    :user => user
  )
end

# Create run directory for puma. This is need by supervisor to store the global puma pidfile.
directory '/var/run/puma' do
  user user
  group user
  mode '0755'
end
