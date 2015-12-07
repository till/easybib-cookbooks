# used as a dependencies recipe for any php package from our ppa archive
include_recipe 'apt::easybib'
include_recipe 'php-fpm::service'
