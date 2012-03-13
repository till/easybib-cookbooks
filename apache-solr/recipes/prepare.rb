package "unzip"
package "openjdk-6-jre-headless"

directory node[:apache_solr][:base_dir] do
  owner     node[:apache_solr][:user]
  group     node[:apache_solr][:group]
  recursive true
end
