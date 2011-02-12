package "munin"

execute "enable mod_rewrite" do
  command "a2enmod rewrite"
end

template "/etc/apache2/sites-enabled/munin" do
  mode "0644"
  source "apache2.erb"
  notifies :restart, "service[apache]"
end
