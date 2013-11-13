php_pecl "opcache" do
  zend_extensions ['opcache.so']
  config_directives node["php-opcache"]["settings"]
  action :setup
end
