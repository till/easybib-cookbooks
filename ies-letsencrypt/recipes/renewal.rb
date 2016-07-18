le_conf = node['ies-letsencrypt']
certbot_bin = le_conf['certbot']['bin']
certbot_cron = le_conf['certbot']['cron']

Chef::Log.info("This may fail the first time due to missing DNS and we need to re-run it.")
execute 'certbot_setup' do
  command certbot_cron
  action :nothing
  ignore_failure true
end

opts = [
  'certonly',
  '--standalone',
  '--agree-tos',
  '--non-interactive',
  '--renew-by-default',
  '--no-self-upgrade',
  '--quiet',
  "--http-01-port #{le_conf['certbot']['port']}"
]

# install cronjob script
template certbot_cron do
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
  notifies :run, 'execute[certbot_setup]', :immediately
end

cron_d 'certbot_renewal' do
  command "#{certbot_cron} 2>&1 | logger -t letsencrypt"
  hour '5,8,11'
  minute 30
  path '/usr/local/bin:/usr/bin'
  not_if do
    le_conf['domains'].empty?
  end
end
