include_recipe 'easybib::role-generic'
include_recipe 'virtualbox'
include_recipe 'vagrant'

deploy_role = 'vagrant-ci'
deployable_apps = node['stack-qa'][deploy_role]['apps']

node['deploy'].each do |app, deploy|

  next unless allow_deploy(app, deployable_apps, deploy_role)

  easybib_deploy app do
    deploy_data deploy
    app app
  end

end
