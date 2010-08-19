deploy.each do |application, deploy|
  default[:deploy][application][:user] = 'www-data'
  default[:deploy][application][:restart_command] = '/etc/init.d/php-fpm restart'
end