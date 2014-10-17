include_recipe 'apt::ppa'
include_recipe 'apt::easybib'

package 'php5-easybib-posix' do
  notifies :reload, 'service[php-fpm]', :delayed
end
