include_recipe 'stack-citationapi::role-phpapp'

if is_aws
  include_recipe 'easybib-deploy::internal-api'
else
  include_recipe 'nginx-app::sitescraper'
end
