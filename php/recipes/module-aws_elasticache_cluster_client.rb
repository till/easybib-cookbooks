include_recipe 'php::dependencies-ppa'

ext = 'amazon-elasticache-cluster-client.so'

source_version = node['amazon-elasticache-cluster-client']['php_version']
module_config = node['php-aws-elasticache']['settings']

php_pecl ext do
  prefix node['php-fpm']['exec_prefix']
  ext_file "#{source_version}-#{ext}"
  action :copy
end

php_config File.basename(ext, '.so') do
  config module_config
  config_dir node['php']['extensions']['config_dir']
  extension_path ext
  load_extension true
  load_priority 10
  suffix ''
  notifies :reload, 'service[php-fpm]', :delayed
end
