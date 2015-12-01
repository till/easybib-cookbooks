deploy_role = node['stack-qa']['deploy_role']
deployable_apps = node['stack-qa'][deploy_role]['apps']

node['deploy'].each do |app, deploy|
  next unless allow_deploy(app, deployable_apps, deploy_role)

  node.override['deploy'][app]['user'] = 'vagrant-ci'
  node.override['deploy'][app]['group'] = 'vagrant-ci'
  node.override['deploy'][app]['home'] = '/home/vagrant-ci'
  deploy = node['deploy'][app]

  opsworks_deploy_user do
    deploy_data deploy
  end

  easybib_deploy app do
    deploy_data deploy
    app app
  end

  easybib_vagrant_user deploy['user'] do
    composer_token node['composer']['oauth_key']
    home_dir deploy['home']
  end
end
