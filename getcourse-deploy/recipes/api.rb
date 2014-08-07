include_recipe "php-fpm::service"
include_recipe "percona::client" if is_aws

node['deploy'].each do |application, deploy|

  next unless allow_deploy(application, ['api', 'feature_flags'], 'api-server')

  easybib_deploy "getcourse-#{application}" do
    deploy_data deploy
    app application
    envvar_json_source "getcourse"
  end

  include_recipe "monit::pecl-manager" if application == 'api'

  service "php-fpm" do
    action :reload
  end

end
