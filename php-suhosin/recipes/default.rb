case node[:lsb][:codename]
when 'lucid'
  include_recipe "apt::ppa"
  include_recipe "apt::easybib"

  package "php5-easybib-suhosin"
when 'precise'
  package "php5-suhosin"
end

include_recipe "php-suhosin::configure"

