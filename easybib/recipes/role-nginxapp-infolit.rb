include_recipe 'easybib::role-phpapp'

if is_aws
  include_recipe 'easybib-deploy::ssl-certificates'
  include_recipe 'nodejs::npm_from_source' # for frontend assets build in before_symlink.rb
  include_recipe 'easybib-deploy::infolit'
else
  include_recipe 'nginx-app::vagrant'
end
