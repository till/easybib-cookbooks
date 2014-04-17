node["deploy"].each do |application, deploy|

  case application
  when 'consumer'
    next unless allow_deploy(application, 'consumer', 'consumer-server')
  when 'signup'
    next unless allow_deploy(application, 'signup', 'signup-server')
  when 'domainadmin'
    next unless allow_deploy(application, 'domainadmin', 'domainadmin-server')
  else
    next
  end

  easybib_opsworks_deploy_dir deploy["deploy_to"] do
    user  deploy["user"]
    group deploy["group"]
    path  deploy["deploy_to"]
  end

  easybib_deploy application do
    deploy_data deploy
    app application
  end

end
