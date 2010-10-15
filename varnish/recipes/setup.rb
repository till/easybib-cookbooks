execute "update keys" do
  command "curl http://repo.varnish-cache.org/debian/GPG-key.txt | apt-key add -"
  action :run
end

remote_file "/etc/apt/sources.list.d/varnish.list" do
  source "varnish.list"
  mode "0644"
  not_if "test -f /etc/apt/sources.list.d/varnish.list"
end

execute "update" do
  command "apt-get update"
  action :run
end

package "varnish"
