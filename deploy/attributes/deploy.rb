deploy.each do |application, deploy|
  node[:deploy][application][:user] = 'www-data'
  node[:deploy][application][:restart_command] = '/etc/init.d/php-fpm stop && /etc/init.d/php-fpm start'
end