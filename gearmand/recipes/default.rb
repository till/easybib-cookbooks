include_recipe 'ies-apt::easybib'

package node['gearmand']['name']

include_recipe 'gearmand::configure'
