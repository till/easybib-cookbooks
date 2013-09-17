template "#{node["php-fpm"]["prefix"]}/etc/php/xdebug.ini" do
  source "xdebug.ini.erb"
  mode   "0644"
  variables(
    :config => node["xdebug"]["config"],
    :prefix => node["php-fpm"]["prefix"]
  )
end
