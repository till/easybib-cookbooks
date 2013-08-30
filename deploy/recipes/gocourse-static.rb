cluster_name   = get_cluster_name()
instance_roles = get_instance_roles()

node["deploy"].each do |application, deploy|

  next unless deploy["deploying_user"]

  case application
  when 'consumer'
    next unless instance_roles.include?('consumer-server')
  when 'signup'
    next unless instance_roles.include?('signup-server')
  when 'domainadmin'
    next unless instance_roles.include?('domainadmin-server')
  else
    next
  end

  opsworks_deploy_dir do
    user  deploy["user"]
    group deploy["group"]
    path  deploy["deploy_to"]
  end

  opsworks_deploy do
    deploy_data deploy
    app application
  end

end
