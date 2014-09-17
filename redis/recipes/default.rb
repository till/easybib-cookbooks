include_recipe 'apt::ppa'

easybib_launchpad node['redis']['ppa'] do
  action :discover
end

package 'redis-server'

include_recipe 'redis::user'
include_recipe 'redis::configure'
