hhvm_config = node["php-hhvm"]["config"]

hhvm_user = node["php-fpm"]["user"]
hhvm_group = node["php-fpm"]["group"]

directory File.dirname(hhvm_config["error_log"]) do
  action :create
  owner hhvm_user
  group hhvm_group
end

template "/etc/hhvm/php.ini" do
  cookbook "php-fpm"
  source "php.ini.erb"
  variables(
    :enable_dl => hhvm_config["enable_dl"],
    :error_log => hhvm_config["error_log"],
    :memory_limit   => hhvm_config["memory_limit"],
    :display_errors => hhvm_config["display_errors"],
    :max_input_vars => node["php-fpm"]["ini"]["max-input-vars"]
  )
  owner hhvm_user
  group hhvm_group
end
