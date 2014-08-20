include_recipe "aptly::repo"

package 'nginx'
include_recipe "nginx-app::service"

include_recipe "nginx-lb::configure"
