# these come pre-installed on scalarium images
package "openjdk-6-jre-headless" do
  action :purge
end

package "openjdk-6-jre-lib" do
  action :purge
end

execute "Accept sun's license" do
  command "echo 'sun-java6-jdk shared/accepted-sun-dlj-v1-1 boolean true' | sudo debconf-set-selections"
end

package "sun-java6-jre"
package "subversion"
