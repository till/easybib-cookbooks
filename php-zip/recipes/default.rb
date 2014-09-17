include_recipe 'php-fpm::source'

php_pecl 'zip' do
  action [ :install, :setup ]
  not_if do
    node['apt']['easybib']['ppa'] == 'ppa:easybib/php55'
  end
end

package 'php5-easybib-zip' do
  action :install
  only_if do
    node['apt']['easybib']['ppa'] == 'ppa:easybib/php55'
  end
end
