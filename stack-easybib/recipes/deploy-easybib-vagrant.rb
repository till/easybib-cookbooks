easybib_envconfig 'www'

easybib_nginx 'www' do
  cookbook 'stack-easybib'
  config_template 'easybib.com.conf.erb'
  notifies :reload, 'service[nginx]', :delayed
  notifies :restart, 'service[php-fpm]', :delayed
end
