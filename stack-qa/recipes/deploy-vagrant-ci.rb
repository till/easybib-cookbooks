deploy_role = node['stack-qa']['deploy_role']
deployable_apps = node['stack-qa'][deploy_role]['apps']

node['deploy'].each do |app, deploy|
  next unless allow_deploy(app, deployable_apps, deploy_role)

  deploy.set['user'] = 'vagrant-ci'
  deploy.set['group'] = 'vagrant-ci'
  deploy.set['home'] = '/home/vagrant-ci'
  deploy.set['shell'] = '/bin/bash'

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
