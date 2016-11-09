Chef::Application.fatal!('This recipe is vagrant only') if is_aws

include_recipe 'ohai'
include_recipe 'memcache'
include_recipe 'stack-citationapi::role-phpapp'
include_recipe 'php::module-xdebug'
include_recipe 'stack-citationapi::deploy-vagrant'
