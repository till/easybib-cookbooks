include_recipe 'ies-apt::easybib'

Chef::Log.info('!!! - This is deprecated! - !!! >>> ies-gearmand')
package node['gearmand']['name']

include_recipe 'gearmand::configure'
