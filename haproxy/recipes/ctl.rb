base_path = node["haproxy"]["ctl"]["base_path"]

# ensure directory exists
directory base_path do
  owner     "root"
  group     "root"
  mode      "0755"
  action    :create
  recursive true
end

git "#{base_path}/haproxyctl" do
  repository "git://github.com/flores/haproxyctl.git"
  reference node["haproxy"]["ctl"]["version"]
  action :sync
end

link "/etc/init.d/haproxyctl" do
  to "#{base_path}/haproxyctl/bin/haproxyctl"
end
