template "/etc/hhvm/php.ini" do
  cookbook "php-fpm"
  source   "php.ini.erb"
  variables(
    :enable_dl      => 'Off',
    :memory_limit   => '-1',
    :display_errors => 'On',
    :max_execution_time => '-1',
    :logfile => node["php-fpm"]["logfile"],
    :tmpdir => node["php-fpm"]["tmpdir"],
    :prefix => node["php-fpm"]["prefix"]
  )
  owner    node["php-fpm"]["user"]
  group    node["php-fpm"]["group"]
end
