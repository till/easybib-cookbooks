include_recipe 'stack-easybib::role-phpapp'

if is_aws
  include_recipe 'stack-easybib::deploy-gearman-worker'
else
  # we use our recipe instead of the default package, because
  # our recipe writes data to disk instead of memory, so it survives
  # a vagrant suspend
  include_recipe 'redis::default'
  include_recipe 'pecl-manager::vagrant'
end
