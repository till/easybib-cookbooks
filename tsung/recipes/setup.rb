package "nginx"
package "erlang-nox"

tsungver="1.3.3"
pkgrev="1"

remote_file "/tmp/tsung_#{tsungver}-#{pkgrev}_all.deb" do
  source "http://tsung.erlang-projects.org/dist/ubuntu/tsung_#{tsungver}-#{pkgrev}_all.deb"
  mode "0644"
  backup false
  create_if_missing
end

dpkg_package "/tmp/tsung_#{tsungver}-#{pkgrev}_all.deb"

directory "/home/ubuntu/.tsung/log" do
  owner "ubuntu"
  group "ubuntu"
  mode "0755"
  action :create
  recursive true
end

remote_file "/etc/nginx/sites-enabled/default" do
  source "tsung.host"
  mode "0644"
  owner "www-data"
  group "www-data"
  action :create
end

service "nginx" do
  supports :status => true, :restart => true
  action [ :enable, :restart ]
end

# put rules in ~/.tsung/rules.xml
# start with tsung start
