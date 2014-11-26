easybib_nginx 'has_htpasswd' do
  config_template 'silex.conf.erb'
  htpasswd '/some_path'
  domain_name 'some_domainname'
  deploy_dir '/some_path'
  app_dir '/some_other_path'
  env_config 'some_env'
end

easybib_nginx 'has_htpasswd_string' do
  config_template 'silex.conf.erb'
  htpasswd 'user:pass'
  domain_name 'some_domainname'
  deploy_dir '/some_path'
  app_dir '/some_other_path'
  env_config 'some_env'
end
