# apache2 related config for munin

execute "enable mod_rewrite" do
  command "a2enmod rewrite"
end

template "/etc/apache2/sites-enabled/munin" do
  mode   "0644"
  source "apache2.erb"
end

service "apache2" do
  supports        :restart => true
  restart_command "/etc/init.d/apache2 restart && sleep 1"
  action          :restart
end
