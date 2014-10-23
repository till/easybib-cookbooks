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
).each do |pkg|
  package pkg do
    action :install
  end
end

# for nginx
package 'fcgiwrap'

include_recipe 'nginx-app::server'
include_recipe 'smokeping::configure'
