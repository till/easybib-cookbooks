node['deploy'].each do |application, deploy|
  if deploy['home'].nil? || deploy['home'] == '/home/www-data'
    Chef::Log.debug('home was empty or /home/www, changing it to /var/www')
    node.default['deploy'][application]['home'] = '/var/www'
  end
end

# fixes "Could not load host key: /etc/ssh/ssh_host_ed25519_key" error
execute 'Generate missing ssh host keys' do
  command 'ssh-keygen -A'
  ignore_failure true
end
