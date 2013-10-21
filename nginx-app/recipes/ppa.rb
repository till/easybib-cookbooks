include_recipe "apt::ppa"

execute "update_nginx_sources" do
  command "apt-get -y -f -q update"
  action :nothing
end

discover_command = "add-apt-repository ppa:nginx/stable"
if node["lsb"]["codename"] == 'precise'
  discover_command = "add-apt-repository --yes ppa:nginx/stable"
end

execute "add ppa:nginx/stable" do
  command discover_command
  notifies :run, "execute[update_nginx_sources]", :immediately
end
