include_recipe "nginx-app::server"

package "tsung"

include_recipe "tsung::configure"
