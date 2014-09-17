php_pecl "phar" do
  config_directives node['php_phar']['config']
  action :setup
end
