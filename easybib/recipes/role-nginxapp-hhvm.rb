include_recipe "hhvm-fcgi"
include_recipe "easybib::role-generic"

if is_aws
  raise "TODO: deployment recipe for nginx/hhvm"
else
  include_recipe "nginx-app::hhvm"
end
