include_recipe 'ies::role-phpapp'
include_recipe 'php::module-posix'
include_recipe 'php::module-pdo_sqlite'

if is_aws
  include_recipe 'stack-qa::deploy-qa'
else
  include_recipe 'ies-mysql'
  include_recipe 'ies-mysql::dev'
  include_recipe 'stack-qa::deploy-qa-vagrant'
end
