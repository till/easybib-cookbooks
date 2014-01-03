node['deploy'].each do |application, deploy|

  next unless allow_deploy(application, 'crossref-collector', 'crossref-www')

  opsworks_deploy_dir do
    user  deploy["user"]
    group deploy["group"]
    path  deploy["deploy_to"]
  end

  easybib_deploy application do
    deploy_data deploy
    app application
  end

end
