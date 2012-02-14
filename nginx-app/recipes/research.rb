# this is for vagrant

if !node[:deploy]
  node[:deploy] = {}
  node[:deploy][:deploy_to] = '/var/www/easybib'
end

include_recipe "nginx-app::vagrant"
