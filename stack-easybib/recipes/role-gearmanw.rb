include_recipe 'stack-easybib::role-phpapp'

include_recipe 'php::module-mysqli'
include_recipe 'php::module-gearman'
include_recipe 'php::module-posix'
include_recipe 'php::module-poppler-pdf'
if is_aws
  include_recipe 'stack-easybib::deploy-gearman-worker'
else
  # we use our recipe instead of the default package, because
  # our recipe writes data to disk instead of memory, so it survives
  # a vagrant suspend
  include_recipe 'redis::default'
  include_recipe 'pecl-manager::vagrant'
end
