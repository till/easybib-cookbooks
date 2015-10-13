include_recipe 'ies::role-generic'
include_recipe 'nginx-app::server'

node['deploy'].each do |application, deploy|
  if allow_deploy(application, 'redirector', 'redirector')
    include_recipe 'nginx-app::redirector'
    include_recipe 'nginx-app::redirector-ssl'
  end
end
