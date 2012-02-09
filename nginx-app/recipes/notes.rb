if !node[:deploy]
  node[:deploy]             = {}
  node[:deploy][:deploy_to] = '/var/www/notes_outline'
end

include_recipe "nginx-app::vagrant"
