include_recipe "php-mysqlnd_uh::compile"
include_recipe "php-fpm::service"

execute "ensure extension is loaded" do
  command  "cat 'extension=mysqlnd_uh.so' > /usr/local/etc/php/mysqlnd_uh.ini"
  notifies :reload, "service[php-fpm]", :delayed
end
