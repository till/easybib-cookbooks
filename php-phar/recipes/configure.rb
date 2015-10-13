php_pecl 'phar' do
  config_directives node['php_phar']['settings']
  action :setup
end
