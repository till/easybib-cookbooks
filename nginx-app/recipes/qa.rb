['bibcd', 'bib-opsstatus'].each do |app_name|
  env_conf = ''
  if has_env?(app_name)
    env_conf = get_env_for_nginx(app_name)
  end

  easybib_nginx app_name do
    config_template 'silex.conf.erb'
    env_config env_conf
    notifies :restart, 'service[nginx]', :delayed
  end
end
