include_recipe "easybib::role-phpapp"

include_recipe "php-pear"

if is_aws
  include_recipe "deploy::internal-api"
else
  include_recipe "nginx-app::sitescraper"
end

#include_recipe "deploy::easybib"
#include_recipe "nginx-app::sitescraper"
