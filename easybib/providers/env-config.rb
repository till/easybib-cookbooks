action :create do
  app = new_resource.app
  deploy_data = new_resource.deploy_data
  path = new_resource.path

  if path.nil?
    if is_aws
      path = "#{deploy_data['deploy_to']}/current/"
    else
      fail "Fatal: easybib_env-config needs path in non-aws setup"
    end
  end

  template "#{path}/.deploy_configuration.ini" do
    mode   "0644"
    cookbook "easybib"
    source "config.ini.erb"
    variables

  end

  new_resource.updated_by_last_action(true)

end
