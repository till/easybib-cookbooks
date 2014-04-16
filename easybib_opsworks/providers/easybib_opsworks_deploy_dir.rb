action :run do

  d = opsworks_deploy_dir do
    user new_resource.user
    group new_resource.group
    path new_resource.path
  end

  new_resource.updated_by_last_action(d.updated_by_last_action?)

end
