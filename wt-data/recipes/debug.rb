get_apps_to_deploy.each do |application, deploy|
  Chef::Log.info(application.inspect)
  Chef::Log.info(deploy.inspect)
end
