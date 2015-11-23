include_recipe 'php::dependencies-ppa'

apc_attributes = node['php-apc']['settings'].to_hash

if is_aws
  apc_attributes = { 'stat' => 0,
                     'slam_defense' => 1,
                     'max_file_size' => '2M' }.merge(apc_attributes)
end

php_ppapackage 'apc' do
  config apc_attributes
  package_name 'apcu'
end
