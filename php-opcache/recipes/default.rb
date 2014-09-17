include_recipe 'apt::easybib'

package 'php5-easybib-opcache'

include_recipe 'php-opcache::configure'
