include_recipe 'php::dependencies-ppa'

node.override['php-soap']['settings']['wsdl_cache_dir'] = node['php-fpm']['tmpdir']
module_config                                           = node['php-soap']['settings']

php_ppa_package 'soap' do
  not_if do
    node['php']['ppa']['package_prefix'] == 'php5-easybib'
  end
end

php_config 'soap' do
  config module_config
  load_priority node['php-soap']['load_priority']
  config_dir node['php']['extensions']['config_dir']
  suffix node['php']['extensions']['ini_suffix']
  notifies :reload, 'service[php-fpm]', :delayed
end
