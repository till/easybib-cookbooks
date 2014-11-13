include_recipe 'smokeping::service'

package 'smokeping' do
  action :install
  options '--no-install-recommends'
  notifies :start, 'service[smokeping]'
end

%w(
  fping curl libauthen-radius-perl libnet-ldap-perl
  libnet-dns-perl libio-socket-ssl-perl libnet-telnet-perl
  libsocket6-perl libio-socket-inet6-perl rrdtool sendmail
  tcptraceroute hping3
).each do |pkg|
  package pkg do
    action :install
  end
end

cookbook_file 'tcpping' do
  path   '/usr/bin/tcpping'
  mode   '0755'
  action :create_if_missing
end

cookbook_file 'HPing.pm' do
  path   '/usr/share/perl5/Smokeping/probes/HPing.pm'
  mode   '0644'
  action :create_if_missing
end

bash "setcap hping" do
  code "setcap cap_net_raw,cap_net_admin=eip /usr/sbin/hping3"
  user 'root'
end

# for nginx
package 'fcgiwrap'

include_recipe 'nginx-app::server'
include_recipe 'smokeping::configure'
