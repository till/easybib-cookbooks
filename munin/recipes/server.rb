package "munin"

execute "enable mod_rewrite" do
  command "a2enmod rewrite"
end

include_recipe "apache2::service"
template "/etc/apache2/sites-enabled/munin" do
  mode "0644"
  source "apache2.erb"
  notifies :restart, "service[apache]"
end
