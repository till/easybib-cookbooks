# install a test composer.json

package "git-core"
package "unzip"
package "curl"

cookbook_file "/tmp/composer.json" do
  mode   "0644"
  source "composer.json"
end

php_composer "/tmp" do
  action [:setup, :install]
end
