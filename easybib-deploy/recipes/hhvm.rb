include_recipe 'hhvm-fcgi::service'
include_recipe 'nginx-app::service'

node['deploy'].each do |application, deploy|

  if application == 'scholar'
    next unless allow_deploy(application, 'scholar', 'hhvm')
  end

  if application == 'featureflags'
    next unless allow_deploy(application, 'featureflags', 'hhvm')
  end

  Chef::Log.info("deploy::#{application} - Deployment started.")
  Chef::Log.info("deploy::#{application} - Deploying as user: #{deploy[:user]} and #{deploy[:group]}")

  easybib_deploy application do
    deploy_data deploy
    app application
  end

  easybib_nginx application do
    config_template 'hhvm.conf.erb'
    domain_name deploy['domains'].join(' ')
    htpasswd  "#{deploy['deploy_to']}/current/htpasswd"
    doc_root deploy['document_root']
    notifies :restart, 'service[nginx]', :delayed
  end

  service 'hhvm-fcgi' do
    action :reload # TODO: this is probably unnessessary
  end

end
