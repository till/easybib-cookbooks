le_conf = node['ies-letsencrypt']
certbot_bin = le_conf['certbot']['bin']

cookbook_file certbot_bin do
  source 'certbot-auto'
  mode 0755
  owner 'root'
  group 'root'
end

# update certbot and install dependencies
execute 'certbot_update' do
  command "#{certbot_bin} --non-interactive --os-packages-only"
end
