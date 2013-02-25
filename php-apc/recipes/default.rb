case node[:lsb][:codename]
when 'lucid'
  package "php5-easybib-apc"
when 'precise'
  package "php-apc"
end

include_recipe "php-apc::configure"
