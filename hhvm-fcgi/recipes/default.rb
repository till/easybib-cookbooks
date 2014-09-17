include_recipe 'hhvm-fcgi::apt'

include_recipe 'hhvm-fcgi::prepare'
include_recipe 'hhvm-fcgi::configure'
include_recipe 'hhvm-fcgi::service'
