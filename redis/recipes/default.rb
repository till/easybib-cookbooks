include_recipe 'apt::ppa'

apt_repository 'redis-ppa' do
  uri    node['redis']['ppa']
end

package 'redis-server'

include_recipe 'redis::user'
include_recipe 'redis::configure'
