include_recipe "apt::ppa"
include_recipe "apt::easybib"

case node[:lsb][:codename]
when 'lucid'
  package "php5-easybib-phar"
when 'precise'
  Chef::Log.debug("ext/phar is included")
end

