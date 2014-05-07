include_recipe "easybib::role-generic"

include_recipe "easybib_deploy::getcourse-static"
include_recipe "nginx-app::getcourse-consumer"
