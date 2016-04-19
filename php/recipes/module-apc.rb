include_recipe 'php::dependencies-ppa'

apc_attributes = node['php-apc']['settings'].to_hash

if is_aws
  apc_attributes = { 'stat' => 0,
                     'slam_defense' => 1,
                     'max_file_size' => '2M' }.merge(apc_attributes)
end

php_ppa_package 'apc' do
  package_name 'apcu'
end

php_config 'apc' do
  config apc_attributes
  load_priority node['php-apc']['load_priority']
  config_dir node['php']['extensions']['config_dir']
  suffix node['php']['extensions']['ini_suffix']
  notifies :reload, 'service[php-fpm]', :delayed
end
