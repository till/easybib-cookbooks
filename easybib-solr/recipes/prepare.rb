package "openjdk-6-dbg"
package "openjdk-6-jre"
package "openjdk-6-jdk"
package "openjdk-6-jre-lib"
package "openjdk-6-jre-headless"
package "subversion"

package "php5"
package "php5-cli"
package "php5-mysql"
package "php-pear"

# for logs
directory "#{node[:easybib_solr][:log_dir]}" do
  owner "root"
  group "root"
  mode "0755"
  action :create
end