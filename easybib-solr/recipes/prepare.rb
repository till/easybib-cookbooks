package "sun-java6-jre"
package "subversion"

# for logs
directory "#{node[:easybib_solr][:log_dir]}" do
  owner "root"
  group "root"
  mode "0755"
  action :create
end