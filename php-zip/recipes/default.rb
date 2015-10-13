include_recipe 'php-fpm::source'
include_recipe 'php-fpm::service'

include_recipe 'apt::ppa'
include_recipe 'apt::easybib'

package 'php5-easybib-zip' do
  action :install
  notifies :reload, 'service[php-fpm]', :delayed
end
