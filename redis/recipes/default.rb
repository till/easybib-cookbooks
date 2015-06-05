include_recipe 'aptly::gpg'

apt_repository 'redis-ppa' do
  uri           ::EasyBib::Ppa.ppa_mirror(node, node['redis']['ppa'])
  distribution  node['lsb']['codename']
  components    ['main']
end

package 'redis-server'

include_recipe 'redis::user'
include_recipe 'redis::configure'
