include_recipe "php-fpm::service"
include_recipe "nginx-app::service"

node['deploy'].each do |application, deploy|

  case application
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
    user  deploy["user"]
    group deploy["group"]
    path  deploy["deploy_to"]
  end

  opsworks_deploy do
    deploy_data deploy
    app application
  end

  env_conf = ''
  if has_env?(application)
    env_conf = get_env_for_nginx(application)
  end

  easybib_nginx application do
    config_template "silex.conf.erb"
    domain_name     deploy['domains'].join(' ')
    htpasswd        "#{deploy['deploy_to']}/current/htpasswd"
    doc_root        deploy['document_root']
    env_config      env_conf
    notifies :restart, "service[nginx]", :delayed
  end

  case application
  when 'bibcd'

    template "#{deploy["deploy_to"]}/current/config/deployconfig.yml" do
      source "empty.erb"
      mode   0644
      variables :content => ::EasyBib.to_php_yaml(node['bibcd']['default'])
    end

    node['bibcd']['apps'].each do |appname, config|
      bibcd_app "adding bibcd app #{appname}" do
        action :add
        path "#{deploy["deploy_to"]}/current/"
        app_name appname
        config config
      end
    end
  when 'travis_asset_browser'
    template "#{deploy["deploy_to"]}/current/config.php" do
      source "config.php.erb"
      mode 0600
      owner "www-data"
      variables :config => node['travis-asset-browser']['config']
    end
  end

  service "php-fpm" do
    action :reload
  end

end
