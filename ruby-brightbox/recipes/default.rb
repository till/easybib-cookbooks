include_recipe "aptly::repo"

package "ruby#{node["ruby-brightbox"]["version"]}"
