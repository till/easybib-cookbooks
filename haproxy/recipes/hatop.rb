base_path = node["haproxy"]["hatop"]["base_path"]

# ensure directory exists
directory base_path do
  owner     "root"
  group     "root"
  mode      "0755"
  action    :create
  recursive true
end

git "#{base_path}/hatop" do
  repository "git://labs.feurix.org/feurix/admin/hatop.git"
  reference node["haproxy"]["hatop"]["version"]
  action :sync
end

link "/usr/sbin/hatop" do
  to "#{base_path}/hatop/bin/hatop"
end

