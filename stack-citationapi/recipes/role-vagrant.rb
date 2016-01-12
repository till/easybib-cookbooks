if is_aws
  Chef::Application.fatal!('This recipe is vagrant only')
end

include_recipe 'ohai'
include_recipe 'stack-easybib::role-phpapp'
include_recipe 'php::module-xdebug'
include_recipe 'nginx-app::service'
include_recipe 'stack-citationapi::deploy-vagrant'
