include_recipe "nginx-app::ppa"

package 'nginx'
include_recipe "nginx-app::service"

include_recipe "nginx-lb::configure"
