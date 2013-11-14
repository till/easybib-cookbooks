include_recipe "php-fpm::source"

php_pecl "zip" do
  action [ :install, :setup ]
end
