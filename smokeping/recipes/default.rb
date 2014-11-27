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
  tcptraceroute
).each do |pkg|
  package pkg do
    action :install
  end
end

# for nginx
package 'fcgiwrap'

include_recipe 'smokeping::tcpping' unless node.fetch('smokeping', {}).fetch('probes', {})['tcpping'].nil?
include_recipe 'smokeping::hping' unless node.fetch('smokeping', {}).fetch('probes', {})['hping'].nil?

include_recipe 'nginx-app::server'
include_recipe 'smokeping::configure'
