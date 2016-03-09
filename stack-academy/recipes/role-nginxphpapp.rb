include_recipe 'stack-easybib::role-phpapp'
include_recipe 'supervisor'

if is_aws
  include_recipe 'easybib-deploy::ssl-certificates'
  include_recipe 'nodejs::npm_from_source' # for frontend assets build in before_symlink.rb
  include_recipe 'stack-academy::deploy'
else
  include_recipe 'nginx-app::vagrant'
end
