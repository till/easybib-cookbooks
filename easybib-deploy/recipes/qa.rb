include_recipe 'php-fpm::service'
include_recipe 'nginx-app::service'

Chef::Resource.send(:include, EasyBib::Php)

node['deploy'].each do |application, deploy|

  case application
  when 'aptly'
    next unless allow_deploy(application, 'aptly')
  when 'bibcd'
    next unless allow_deploy(application, 'bibcd')
  when 'bib_opsstatus'
    next unless allow_deploy(application, 'bib_opsstatus', 'bib-opsstatus')
  when 'travis_asset_browser'
    next unless allow_deploy(application, 'travis_asset_browser', 'travis-asset-browser')
  else
    Chef::Log.info("deploy::qa - #{application} skipped")
    next
  end

  Chef::Log.info("deploy::#{application} - Deployment started.")
  Chef::Log.info("deploy::#{application} - Deploying as user: #{deploy[:user]} and #{deploy[:group]}")

  opsworks_deploy_dir do
    user  deploy['user']
    group deploy['group']
    path  deploy['deploy_to']
  end

  easybib_deploy application do
    deploy_data deploy
    app application
  end

  env_conf = ::EasyBib::Config.get_env('nginx', application, node)

  easybib_nginx application do
    config_template 'silex.conf.erb'
    domain_name     deploy['domains'].join(' ')
    htpasswd        "#{deploy['deploy_to']}/current/htpasswd"
    doc_root        deploy['document_root']
    env_config      env_conf
    notifies :reload, 'service[nginx]', :delayed
  end

  case application
  when 'bibcd'

    template "#{deploy['deploy_to']}/current/config/deployconfig.yml" do
      source 'empty.erb'
      mode   0644
      variables :content => to_php_yaml(node['bibcd']['default'])
    end

    node['bibcd']['apps'].each do |appname, config|
      bibcd_app "adding bibcd app #{appname}" do
        action :add
        path "#{deploy['deploy_to']}/current/"
        app_name appname
        config config
      end
    end
  when 'aptly'

    include_recipe 'aptly::setup'
    aptly_cronjob 'easybib-s3' do
      path "#{deploy['deploy_to']}/current/"
    end
  end

  service 'php-fpm' do
    action node['easybib-deploy']['php-fpm']['restart-action']
  end

end
