package "nginx"
package "gnuplot-nox"
package "libtemplate-perl"
package "libhtml-template-perl"
package "libhtml-template-expr-perl"
package "erlang-nox"

tsungver="1.3.3"
pkgrev="1"

remote_file "#{Chef::Config[:file_cache_path]}/tsung_#{tsungver}-#{pkgrev}_all.deb" do
  source "http://tsung.erlang-projects.org/dist/ubuntu/tsung_#{tsungver}-#{pkgrev}_all.deb"
  mode "0644"
  backup false
  not_if "test -f #{Chef::Config[:file_cache_path]}/tsung_#{tsungver}-#{pkgrev}_all.deb"
end

#dpkg_package "#{Chef::Config[:file_cache_path]}/tsung_#{tsungver}-#{pkgrev}_all.deb"

execute "Install tsung package" do
  command "dpkg -i #{Chef::Config[:file_cache_path]}/tsung_#{tsungver}-#{pkgrev}_all.deb"
  not_if "test -f /usr/bin/tsung"
end

home_dir="/home/ubuntu"

directory "#{home_dir}/.tsung/log" do
  owner "ubuntu"
  group "ubuntu"
  mode "0755"
  action :create
  recursive true
end

template "#{home_dir}/.tsung/tsung.xml" do
  source "tsung.xml.erb"
  owner "ubuntu"
  group "ubuntu"
end

remote_file "#{home_dir}/.tsung/listids.csv" do
  source "listids.csv"
  mode "0644"
  owner "ubuntu"
  group "ubuntu"
  action :create
end

remote_file "/etc/nginx/sites-available/default" do
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

# put rules in ~/.tsung/tsung.xml
# start with tsung start
