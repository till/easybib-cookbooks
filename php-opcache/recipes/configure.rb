php_pecl 'opcache' do
  zend_extensions ['opcache.so']
  config_directives node['php-opcache']['settings']
  action :setup
  only_if do
    node['apt']['easybib']['ppa'] == 'ppa:easybib/php55'
  end
end
