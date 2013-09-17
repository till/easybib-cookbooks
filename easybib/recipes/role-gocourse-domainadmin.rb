include_recipe "easybib::setup"
include_recipe "loggly::setup"
include_recipe "nginx-app::server"
include_recipe "deploy::gocourse-static"
include_recipe "nginx-app::gocourse-domainadmin"

if is_aws()
  include_recipe "newrelic"
end
