#warning: Despite the name, this is used for all internal apis: worldcat, yahooboss, etc., too.

include_recipe "easybib::role-phpapp"

include_recipe "php-pear"

if is_aws
  include_recipe "deploy::internal-api"
else
  include_recipe "nginx-app::sitescraper"
end
