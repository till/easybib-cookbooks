include_recipe "easybib::role-phpapp"

if is_aws
  include_recipe "easybib_deploy::internal-api"
else
  include_recipe "nginx-app::sitescraper"
end
