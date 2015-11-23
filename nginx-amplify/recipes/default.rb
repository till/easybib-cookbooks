apt_repository 'nginx-amplify' do
  key node['nginx-amplify']['apt']['key']
  uri node['nginx-amplify']['apt']['repository']
  distribution node['lsb']['codename']
  components ['amplify-agent']
end

package_action = :upgrade
package_action = :install unless node['nginx-amplify']['version'].nil?

package 'nginx-amplify-agent' do
  action package_action
  version node['nginx-amplify']['version']
end

include_recipe 'nginx-amplify::configure'
