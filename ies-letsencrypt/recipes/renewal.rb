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

cron_d 'certbot_renewal' do
  command "#{certbot_bin} #{opts.join(' ')}"
  minute 30
  hour '5,8'
  not_if do
    le_conf['domains'].empty?
  end
end
