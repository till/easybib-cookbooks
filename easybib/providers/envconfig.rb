action :create do
  app = new_resource.app
  path = new_resource.path

  if path.nil?
    if ::EasyBib.is_aws
      path = "#{deploy_data['deploy_to']}/current/"
    else
      fail "Fatal: easybib_env-config needs path in non-aws setup"
    end
  end

  ["ini", "php", "shell"].each do |format|
    template "#{path}/.deploy_configuration.#{format}" do
      mode   "0644"
      cookbook "easybib"
      source "empty.erb"
      variables(
        :content => ::EasyBib::Config.get_configcontent(format, app)
      )
    end
  end

  new_resource.updated_by_last_action(true)

end
