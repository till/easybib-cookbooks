template "#{node["php-fpm"]["prefix"]}/etc/php/mysqli-settings.ini" do
  source "mysqli.ini.erb"
  variables({
    :reconnect => node["php-mysqli"]["reconnect"]
  })
end
