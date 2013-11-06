include_recipe "easybib::setup"
include_recipe "loggly::setup"
include_recipe "nginx-app::server"

if is_aws()
  include_recipe "newrelic"
end
