include_recipe 'php::dependencies-ppa'

apt_repository 'poppler' do
  uri          node['poppler']['package_uri']
  distribution node['poppler']['package_distro']
  components   node['poppler']['package_components']
  key          node['poppler']['package_key_uri']
end

package_list = node['poppler']['package_list']
package_list.each do |package_name|
  package package_name
end

ext = 'poppler.so'
php_config File.basename(ext, '.so') do
  config {}
  config_dir node['php']['extensions']['config_dir']
  extension_path ext
  load_extension true
  load_priority 10
  suffix ''
  notifies :reload, 'service[php-fpm]', :delayed
end
