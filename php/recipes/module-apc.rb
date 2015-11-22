include_recipe 'php::dependencies-ppa'

package "#{node['php']['ppa']['package_prefix']}-apcu" do
  action :install
end

apc_attributes = node['php-apc']['settings'].to_hash

if is_aws
  apc_attributes = { 'stat' => 0,
                     'slam_defense' => 1,
                     'max_file_size' => '2M' }.merge(apc_attributes)
end

php_config 'apc' do
  config apc_attributes
end
