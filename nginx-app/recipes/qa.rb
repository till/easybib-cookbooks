['bibcd', 'bib-opsstatus'].each do |app_name|
  env_conf = ::EasyBib::Config.get_env('nginx', app_name, node)

  easybib_nginx app_name do
    config_template 'silex.conf.erb'
    env_config env_conf
    notifies :restart, 'service[nginx]', :delayed
  end
end
