# this is for vagrant

if !node[:deploy]
  node[:deploy] = {}
  node[:deploy][:deploy_to] = '/var/www/easybib'
end

if !node[:docroot]
  node[:docroot] = 'public'
end

package "libicu-dev"
php_pecl "intl" do
    action [:install, :setup]
end

include_recipe "nginx-app::vagrant"