node['deploy'].each do |application, deploy|
  if deploy['home'].nil? || deploy['home'] == "/home/www-data"
    Chef::Log.debug("home was empty or /home/www, changing it to /var/www")
    node.default['deploy'][application]['home'] = '/var/www'
  end
end
