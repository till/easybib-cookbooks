# this is for vagrant

if !node[:deploy]
  node[:deploy] = {}
  node[:deploy][:deploy_to] = '/var/www/easybib'
end

if !node[:docroot]
  node[:docroot] = 'public'
end

include_recipe "php-intl"
include_recipe "nginx-app::vagrant"
