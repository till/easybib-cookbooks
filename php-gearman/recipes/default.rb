include_recipe "php-fpm::service"

include_recipe "apt::ppa"
include_recipe "apt::easybib"

case node[:lsb][:codename]
when 'lucid'
  p = "php5-easybib-gearman"
when 'precise'
  remote_file "/tmp/libgearman4_0.13-1_amd64.deb" do
    source "http://ftp.de.debian.org/debian/pool/main/g/gearmand/libgearman4_0.13-1_amd64.deb"
  end

  package "libgearman4" do
    action   :install
    source   "/tmp/libgearman4_0.13-1_amd64.deb"
    provider Chef::Provider::Package::Dpkg
  end

  p = "php5-gearman"
end

package p do
  notifies :reload, resources(:service => "php-fpm"), :delayed
end
