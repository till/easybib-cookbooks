include_recipe 'easybib::role-generic'

node['deploy'].each do |application, deploy|
  if allow_deploy(application, 'redirector', 'redirector')
    include_recipe 'nginx-app::redirector'
    include_recipe 'nginx-app::redirector-ssl'
  end
end
