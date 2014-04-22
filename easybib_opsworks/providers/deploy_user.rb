action :run do

  Chef::Log.debug("I am in easybib_opsworks_deploy_user. Deploy_data is #{new_resource.deploy_data}.")

  d = opsworks_deploy_user do
    deploy_data new_resource.deploy_data
  end

  new_resource.updated_by_last_action(d.updated_by_last_action?)

end
