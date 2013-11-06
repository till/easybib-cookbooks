include_recipe "easybib::role-generic"

include_recipe "deploy::gocourse-static"
include_recipe "nginx-app::gocourse-consumer"