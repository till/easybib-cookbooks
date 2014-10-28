include_recipe 'apt::easybib'

package 'php5-easybib-imagick' do
  notifies :reload, 'service[php-fpm]', :delayed
end