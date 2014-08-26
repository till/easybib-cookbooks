node["deploy"].each do |application, deploy|

  case application
  when 'consumer'
    next unless allow_deploy(application, 'consumer', 'consumer-server')
  when 'signup'
    next unless allow_deploy(application, 'signup', 'signup-server')
  when 'domainadmin'
    next unless allow_deploy(application, 'domainadmin', 'domainadmin-server')
  when 'management'
    next unless allow_deploy(application, 'management', 'management-server')
  else
    next
  end

  easybib_deploy application do
    deploy_data deploy
    app application
  end
  
end
