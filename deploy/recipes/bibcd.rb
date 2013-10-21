node['deploy'].each do |application, deploy|

  next unless allow_deploy(application, 'bibcd')

  Chef::Log.info("deploy::bibcd - Deployment started.")
  Chef::Log.info("deploy::bibcd - Deploying as user: #{deploy["user"]} and #{deploy["group"]}")

  opsworks_deploy_user do
    deploy_data deploy
    app application
  end

  opsworks_deploy_dir do
    user  deploy["user"]
    group deploy["group"]
    path  deploy["deploy_to"]
  end

  opsworks_deploy do
    deploy_data deploy
    app application
  end

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

  service "php-fpm" do
    action :reload
  end

end
