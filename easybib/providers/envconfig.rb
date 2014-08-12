action :create do
  app = new_resource.app

  if new_resource.path.nil?
    if ::EasyBib.is_aws(node)
      path = node['deploy'][app]['deploy_to'] + '/current/'
    else
      path = ::EasyBib.get_vagrant_appdir(node, app)
    end
  else
    path = new_resource.path
  end

  Chef::Log.info("writing envconfig for #{app} to #{path}")

  ["ini", "php", "sh"].each do |format|
    template "#{path}/.deploy_configuration.#{format}" do
      mode   "0644"
      cookbook "easybib"
      source "empty.erb"
      variables(
        :content => ::EasyBib::Config.get_configcontent(format, app, node)
      )
    end
  end

  new_resource.updated_by_last_action(true)

end
