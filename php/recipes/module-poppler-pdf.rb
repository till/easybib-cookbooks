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

php_ppa_package 'poppler-pdf'
