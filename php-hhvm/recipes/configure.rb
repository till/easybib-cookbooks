template "/etc/hhvm/php.ini" do
  cookbook "php-fpm"
  source   "php.ini.erb"
  variables(
    :enable_dl      => 'Off',
    :memory_limit   => '-1',
    :display_errors => 'On'
  )
  owner    node["php-fpm"]["user"]
  group    node["php-fpm"]["group"]
end
