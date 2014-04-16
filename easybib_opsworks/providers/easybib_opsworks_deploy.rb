action :run do

  d = opsworks_deploy do
    app new_resource.app
    deploy_data new_resource.deploy_data
  end

  new_resource.updated_by_last_action(d.updated_by_last_action?)

end
