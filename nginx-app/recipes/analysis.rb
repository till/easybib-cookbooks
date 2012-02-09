if !node[:deploy]
  node[:deploy] = {}
  node[:deploy][:deploy_to] = '/var/www/citationalysis'
end

include_recipe "nginx-app::vagrant"
