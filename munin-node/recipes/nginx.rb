# prior to 10.04 we have to download them ourselves
munin_plugins = ["nginx_status", "nginx_requests", "nginx_memory"]

directory "/opt/munin-nginx" do
  mode "0755"
end

remote_file "/opt/munin-nginx/nginx_memory" do
  source "http://muninexchange.projects.linpro.no/download.php?phid=626"
  mode "0755"
end

remote_file "/opt/munin-nginx/nginx_status" do
  source "http://muninexchange.projects.linpro.no/download.php?phid=65"
  mode "0755"
end

remote_file "/opt/munin-nginx/nginx_requests" do
  source "http://muninexchange.projects.linpro.no/download.php?phid=64"
  mode "0755"
end

munin_plugins.each do |plugin|
  link "/etc/munin/plugins/#{plugin}" do
    to "/opt/munin-nginx/#{plugin}"
  end
end
