include_recipe "hhvm-fcgi"
include_recipe "easybib::role-generic"

if is_aws
  ##include_recipe "easybib-deploy::api" XXX TODO
else
  include_recipe "nginx-app::hhvm"
end
