include_recipe "apt::ppa"
include_recipe "apt::easybib"

package node[:gearmand][:name]

include_recipe "gearmand::configure"
