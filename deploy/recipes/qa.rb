include_recipe "php-fpm::service"
include_recipe "nginx-app::service"

node['deploy'].each do |application, deploy|

  if application == 'bibcd'
    next unless allow_deploy(application, 'bibcd')
  end

  if application == 'bib-opsstatus'
    next unless allow_deploy(application, 'bib-opsstatus')
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
    domain_name deploy['domains'].join(' ')
    doc_root deploy['document_root']
    env_config env_conf
    notifies :restart, "service[nginx]", :delayed
  end
  
  if application == 'bibcd'
    template "#{deploy["deploy_to"]}/current/config/deployconfig.yml" do
      source "empty.erb"
      mode   0644
      #This is an ugly quick hack: Ruby Yaml adds !map:Chef::Node::ImmutableMash which the Symfony Yaml 
      #parser doesnt like. So lets remove it.
      variables :content => YAML::dump(node['bibcd']['default']).gsub('!map:Chef::Node::ImmutableMash','')
    end

    node['bibcd']['apps'].each do |appname, config|
      bibcd_app "adding bibcd app #{appname}" do
        action :add
        path "#{deploy["deploy_to"]}/current/"
        app_name appname
        config config
      end
    end
  end
  
  service "php-fpm" do
    action :reload
  end

end
