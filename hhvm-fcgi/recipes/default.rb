include_recipe "hhvm-fcgi::prepare"
include_recipe "hhvm-fcgi::configure-hhvm"
include_recipe "hhvm-fcgi::configure"
include_recipe "hhvm-fcgi::service"
