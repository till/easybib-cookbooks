package "openjdk-6-dbg"
package "openjdk-6-jre"
package "openjdk-6-jdk"
package "openjdk-6-jre-lib"
package "openjdk-6-jre-headless"

# for logs
directory "/var/log/solr" do
  owner "root"
  group "root"
  mode "0755"
  action :create
end

# for ebs
directory "#{node["solr"]["working_directory"] do
  owner "root"
  group "root"
  mode "0755"
  action :create
end