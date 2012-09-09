include_recipe "php-mysqlnd_uh::compile"

execute "ensure extension is loaded" do
  command "cat 'extension=mysqlnd_uh.so' > /usr/local/etc/php/mysqlnd_uh.ini"
end

include_recipe "php-fpm::service"
