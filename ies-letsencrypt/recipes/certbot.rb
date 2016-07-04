certbot_bin = '/usr/local/bin/certbot-auto'

cookbook_file certbot_bin do
  source 'certbot-auto'
  mode 0755
  owner 'root'
  group 'root'
end

# update certbot and install dependencies
execute "#{certbot_bin} --non-interactive --os-packages-only"

opts = [
  'certonly',
  '--agree-tos',
  '--renew-by-default',
  '--standalone-supported-challenges',
  'http-01',
  "--http-01-port #{node['ies-letsencrypt']['certbot']['port']}",
]

renewal_domains = node['ies-letsencrypt']['domains'].map { |domain|
  "-d #{domain}"
}.join(' ')

cron_d 'certbot-renewal' do
  command "#{certbot_bin} #{opts.join(' ')} #{renewal_domains}"
  not_if do
    node['ies-letsencrypt']['domains'].empty?
  end
end
