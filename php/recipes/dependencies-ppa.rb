# used as a dependencies recipe for any php package from our ppa archive
include_recipe 'ies-apt::ppa'
include_recipe 'aptly::gpg'

ppa_config = node['php']['ppa']

apt_repository ppa_config['name'] do
  uri           ppa_config['uri']
  distribution  node['lsb']['codename']
  components    ['main']
end

include_recipe 'php-fpm::service'
