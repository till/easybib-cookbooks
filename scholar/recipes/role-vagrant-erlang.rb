include_recipe 'ohai'

include_recipe 'easybib::role-generic'

include_recipe 'erlang-packages::aptrepo'

package 'esl-erlang'
