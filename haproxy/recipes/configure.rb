include_recipe 'haproxy::service'

directory '/etc/haproxy/errors/' do
  recursive true
  mode '0755'
  action :create
end

node['haproxy']['errorloc'].each do |code, file|
  cookbook_file "/etc/haproxy/errors/#{file}" do
    source "#{node['haproxy']['templates_directory']}/#{file}"
    owner 'haproxy'
    group 'haproxy'
    mode 0644
  end
end

certificate = "#{node['ssl-deploy']['directory']}/cert.combined.pem"

# A chicken-egg problem!
#
# HaProxy should be installed and configured, but HaProxy is also required
# for the SSL challenge to let's encrypt or the SSL certificates get installed
# via a deploy later on.
#
# The easiest way to overcome this, is to generate a self-signed certificate
# to bridge the gap, and then overwrite the certificate from let's encrypt or
# a deployment at a later stage.
if node['haproxy']['ssl'] != 'off' && !File.exist?(certificate)
  # create a self-signed cert
  package 'openssl'

  ies_ssl_selfsigned 'example.org'

  # install self-signed cert so we can continue
  fake_deploy = {}
  fake_deploy['ssl_certificate_key'] = '/tmp/example.org.key'
  fake_deploy['ssl_certificate'] = '/tmp/example.org.crt'

  easybib_sslcertificate 'install_ssl' do
    deploy fake_deploy
    action :create
  end
end

template '/etc/haproxy/haproxy.cfg' do
  source 'haproxy.easybib.cfg.erb'
  owner 'root'
  group 'root'
  mode 0644
  notifies :reload, 'service[haproxy]'
end

service 'haproxy' do
  action [:enable, :start]
end

execute "echo 'checking if HAProxy is not running - if so start it'" do
  not_if 'pgrep haproxy'
  notifies :start, 'service[haproxy]'
end

include_recipe 'haproxy::monit'
