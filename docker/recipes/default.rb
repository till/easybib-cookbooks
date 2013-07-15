include_recipe "docker::dependencies"

package "lxc-docker"

cookbook_file "/etc/init.d/docker" do
  owner "root"
  group "root"
  source "docker"
  mode 0750
end
