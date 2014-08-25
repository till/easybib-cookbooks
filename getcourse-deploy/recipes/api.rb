include_recipe "php-fpm::service"

if is_aws
  include_recipe "percona::client"
  include_recipe "awscli"

  chef_gem "travis" do
    action :install
  end

end

node['deploy'].each do |application, deploy|

  next unless allow_deploy(application, 'api', 'api-server')

  easybib_deploy "getcourse-#{application}" do
    deploy_data deploy
    app application
    envvar_json_source "getcourse"
    cronjob_role node["getcourse-deploy"]["master_server_layer"]
    instance_roles node["opsworks"]["instance"]["layers"]
  end

  credential_dir = "#{node["opsworks"]["deploy_user"]["home"]}/.aws"

  directory credential_dir do
    owner deploy["user"]
    group deploy["group"]
    mode 0700
  end

  template "#{credential_dir}/credentials" do
    cookbook "awscli"
    source "credentials.erb"
    owner deploy["user"]
    group deploy["group"]
    mode 0600
    variables(
      :key_id => node["getcourse"]["env"]["aws"]["access_key"],
      :secret => node["getcourse"]["env"]["aws"]["secret_key"]
    )
  end

  include_recipe "monit::pecl-manager"

  cron_d "frontend-acceptance-tests" do
    action :create
    hour 3
    user deploy["user"]
    command "/srv/www/api/current/bin/frontend-acceptance.rb 'acceptance' '#{node["easybib_deploy"]["travis-token"]}'"
    path "/usr/local/bin:/usr/bin:/bin"
    only_if do
      ::EasyBib.deploy_crontab?(
        node["opsworks"]["instance"]["layers"],
        node["getcourse-deploy"]["master_server_layer"]
      )
    end
  end

  service "php-fpm" do
    action :reload
  end

end
