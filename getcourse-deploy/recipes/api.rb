include_recipe "php-fpm::service"
include_recipe "percona::client" if is_aws

node['deploy'].each do |application, deploy|

  next unless allow_deploy(application, ['api', 'feature_flags'], 'api-server')

  easybib_deploy "getcourse-#{application}" do
    deploy_data deploy
    app application
    envvar_json_source "getcourse"
    cronjob_role node["getcourse-deploy"]["master_server_layer"]
    instance_roles node["opsworks"]["instance"]["layers"]
  end

  if application == 'api'

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
  end

  service "php-fpm" do
    action :reload
  end

end
