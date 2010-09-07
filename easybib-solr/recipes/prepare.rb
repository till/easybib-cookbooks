execute "Accept sun's license" do
  command "echo 'sun-java6-jdk shared/accepted-sun-dlj-v1-1 boolean true' | sudo debconf-set-selections"
end

package "sun-java6-jre"
package "subversion"

# for logs
directory "#{node[:easybib_solr][:log_dir]}" do
  owner "root"
  group "root"
  mode "0755"
  action :create
end