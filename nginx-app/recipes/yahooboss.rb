if !node[:deploy]
  node[:deploy] = {}
  node[:deploy][:deploy_to] = '/var/www/yahooboss'
end

include_recipe "nginx-app::analysis"
