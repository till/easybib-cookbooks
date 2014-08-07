node['deploy'].each do |application, deploy|

  next unless allow_deploy(application, 'crossref_collector', 'crossref-www')

  easybib_deploy application do
    deploy_data deploy
    app application
  end

end
