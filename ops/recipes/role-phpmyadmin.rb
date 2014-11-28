include_recipe 'easybib::role-phpapp'
include_recipe 'php-mysqli::configure'

node['deploy'].each do |app, deploy|

  next unless allow_deploy(app, 'phpmyadmin')

  easybib_nginx app do
    config_template 'silex.conf.erb'
    domain_name ::EasyBib::Config.get_domains(node, app)
    notifies :restart, 'service[nginx]'
  end

  easybib_deploy app do
    deploy_data deploy
  end

  service 'php-fpm' do
    action :reload
  end

end
