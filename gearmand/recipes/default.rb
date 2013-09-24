include_recipe "apt::ppa"
include_recipe "apt::easybib"

node.set['gearmand']['name'] = 'gearmand-easybib'

package node['gearmand']['name']

include_recipe "gearmand::configure"
