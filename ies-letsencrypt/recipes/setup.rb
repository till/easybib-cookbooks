le_conf = node['ies-letsencrypt']
certbot_bin = le_conf['certbot']['bin']

etc_dir = le_conf['certbot']['etc']

template "#{etc_dir}/cli.ini" do
  source 'cli.ini.erb'
  mode   0644
  variables(
    :domains => node['ies-letsencrypt']['domains'],
    :email => node['sysop_email']
  )
end

opts = [
  'certonly',
  '--agree-tos --renew-by-default',
  '--non-interactive',
  '--no-self-upgrade',
  '--quiet',
  "--standalone --http-01-port #{le_conf['certbot']['port']}"
]

execute 'certbot_certonly' do
  command "#{certbot_bin} #{opts.join(' ')}"
  not_if do
    File.exist?("#{etc_dir}/live/")
  end
end
