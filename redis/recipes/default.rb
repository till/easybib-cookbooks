include_recipe "aptly::repo"

package "redis-server"

include_recipe "redis::user"
include_recipe "redis::configure"
