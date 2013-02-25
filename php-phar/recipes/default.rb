case node[:lsb][:codename]
when 'lucid'
  include_recipe "apt::ppa"
  include_recipe "apt::easybib"
  package "php5-easybib-phar"
when 'precise'
  Chef::Log.debug("ext/phar is included")
end

