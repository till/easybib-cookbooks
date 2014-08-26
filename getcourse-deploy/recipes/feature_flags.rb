include_recipe "php-fpm::service"

node['deploy'].each do |application, deploy|

  next unless allow_deploy(application, 'feature_flags', 'api-server')

  easybib_deploy "getcourse-#{application}" do
    deploy_data deploy
    app application
    envvar_json_source "getcourse"
  end

  service "php-fpm" do
    action :reload
  end

end
