unless node[:deploy].nil?
  deploy.each do |application, deploy|
    node[:deploy][application][:user] = 'www-data'
    node[:deploy][application][:group] = 'www-data'
    node[:deploy][application][:shell] = '/bin/sh'
    node[:deploy][application][:home] = '/var/www'
  	node[:deploy][application][:restart_command] = '/etc/init.d/php-fpm restart'
  end
end
