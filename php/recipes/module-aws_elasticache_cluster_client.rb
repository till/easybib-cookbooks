include_recipe 'php::dependencies-ppa'

ext = 'amazon-elasticache-cluster-client.so'

source_version = node['amazon-elasticache-cluster-client']['php_version']

cookbook_file "/usr/lib/php/20151012/#{ext}" do
  source "#{source_version}-#{ext}"
  mode 0644
end

php_config File.basename(ext, '.so') do
  config {}
  config_dir node['php']['extensions']['config_dir']
  extension_path ext
  load_extension true
  load_priority 10
  suffix ''
  notifies :reload, 'service[php-fpm]', :delayed
end
