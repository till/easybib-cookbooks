apt_repository 'nginx-amplify' do
  key node['nginx-amplify']['key']
  uri ::EasyBib::Ppa.ppa_mirror(node, node['nginx-amplify']['repository'])
  distribution node['lsb']['codename']
  components ['amplify-agent']
end

package 'nginx-amplify-agent'

include_recipe 'nginx-amplify::configure'
