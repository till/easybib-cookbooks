include_recipe 'php-fpm::service'

include_recipe 'ies-apt::easybib'

p = 'php5-easybib-xsl'

package p do
  notifies :reload, 'service[php-fpm]', :delayed
end
