le_conf = node['ies-letsencrypt']
certbot_bin = le_conf['certbot']['bin']

opts = [
  'certonly',
  '--standalone',
  '--non-interactive',
  '--renew-by-default',
  '--no-self-upgrade',
  '--quiet',
  "--http-01-port #{le_conf['certbot']['port']}"
]

# install cronjob script
template le_conf['certbot']['cron'] do
  source 'certbot-cronjob.sh.erb'
  mode 0755
  owner 'root'
  group 'root'
  variables(
    :certbot_bin => certbot_bin,
    :etc_dir => le_conf['certbot']['etc'],
    :opts => opts,
    :ssl_dir => le_conf['ssl_dir']
  )
end

cron_d 'certbot_renewal' do
  command "#{le_conf['certbot']['cron']} 2>&1 | logger -t letsencrypt"
  hour '5,8,11'
  minute 30
  path '/usr/local/bin:/usr/bin'
  not_if do
    le_conf['domains'].empty?
  end
end
