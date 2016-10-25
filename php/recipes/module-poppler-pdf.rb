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

poppler_install_dir = '/opt/easybib/lib/php/extensions/no-debug-non-zts-20131226'
Chef::Log.debug("Copying #{poppler_install_dir}/poppler.so to PHP extension dir")
execute 'move-poppler-so' do
  cwd poppler_install_dir
  command 'cp poppler.so `/usr/bin/php5.6 -r "echo ini_get(\"extension_dir\");"`/poppler.so'
  ignore_failure true
  only_if { ::File.exist?("#{poppler_install_dir}/poppler.so") }
end

ext = 'poppler.so'
php_config File.basename(ext, '.so') do
  config node['php-poppler']['settings']
  config_dir node['php']['extensions']['config_dir']
  extension_path ext
  load_extension true
  load_priority 10
  suffix ''
  notifies :reload, 'service[php-fpm]', :delayed
end
