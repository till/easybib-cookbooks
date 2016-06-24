certbot_bin = '/usr/local/bin/certbot-auto'

cookbook_file certbot_bin do
  source 'certbot-auto'
  mode 0755
  owner 'root'
  group 'root'
end

# update certbot and install dependencies
execute "#{certbot_bin} --non-interactive --os-packages-only"
