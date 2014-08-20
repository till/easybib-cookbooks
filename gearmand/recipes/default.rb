include_recipe "aptly::repo"

package node['gearmand']['name']

include_recipe "gearmand::configure"
