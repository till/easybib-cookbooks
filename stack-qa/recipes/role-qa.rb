include_recipe 'stack-easybib::role-phpapp'

include_recipe 'php::module-posix'
if is_aws
  include_recipe 'easybib-deploy::qa'
else
  include_recipe 'nginx-app::qa'
end
