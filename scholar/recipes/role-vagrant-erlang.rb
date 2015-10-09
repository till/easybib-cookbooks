include_recipe 'ohai'

include_recipe 'ies::role-generic'
include_recipe 'nginx-app::server'

include_recipe 'erlang-packages::aptrepo'

package 'esl-erlang'
package 'build-essential'

include_recipe 'nodejs'
include_recipe 'nodejs::npm'
