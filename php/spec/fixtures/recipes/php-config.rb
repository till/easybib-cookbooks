php_config node['config-spec']['name'] do
  config node['config-spec']['config']
  prefix_dir node['config-spec']['prefix_dir']
  extension_path node['config-spec']['extension_path']
  load_extension node['config-spec']['load_extension']
  zend_extension node['config-spec']['zend_extension']
end
