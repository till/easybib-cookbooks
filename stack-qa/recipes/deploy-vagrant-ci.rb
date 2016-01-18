deploy_role = node['stack-qa']['vagrant-ci']['deploy']['opsworks-layer']
deployable_apps = node['stack-qa']['vagrant-ci']['apps']

node['deploy'].each do |app, deploy|
  next unless allow_deploy(app, deployable_apps, deploy_role)

  node.override['deploy'][app]['user'] = node['stack-qa']['vagrant-ci']['deploy']['user']
  node.override['deploy'][app]['group'] = node['stack-qa']['vagrant-ci']['deploy']['group']
  node.override['deploy'][app]['home'] = node['stack-qa']['vagrant-ci']['deploy']['home']
  deploy = node['deploy'][app]

  begin
    opsworks_deploy_user do
      deploy_data deploy
    end
  rescue NoMethodError
    # This is a very weird workaround, and ugly.
    # The reason why this has to be done is because opsworks_deploy_user is from the aws cookbooks,
    # which is a different repo and merged together in opsworks - so wont be available for our test suite.
    # Since this should NEVER happen in a chef run, I am doing the warning log stmt.
    # also, a chef run in opsworks would fail anyway, since easybib_deploy depends on opsworks
    Chef::Log.warn('opsworks_deploy_user is not defined. This should only happen in rspec tests!')
  end

  easybib_deploy app do
    deploy_data deploy
    app app
  end

  package 'keychain' #needed by easybib_vagrant_user

  easybib_vagrant_user deploy['user'] do
    composer_token node['composer']['oauth_key']
    home_dir deploy['home']
  end
end
