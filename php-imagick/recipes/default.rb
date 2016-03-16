include_recipe 'ies-apt::easybib'

package 'php5-easybib-imagick' do
  notifies :reload, 'service[php-fpm]', :delayed
end
