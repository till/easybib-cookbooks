include_recipe 'ohai'

include_recipe 'easybib::role-generic'

include_recipe 'erlang-packages::aptrepo'

package 'esl-erlang'

include_recipe 'nodejs'
include_recipe 'nodejs::npm'
