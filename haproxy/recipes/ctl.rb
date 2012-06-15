git "/usr/share/haproxyctl" do
  repository "git://github.com/flores/haproxyctl.git"
  reference "0.1.0"
  action :sync
end

link "/etc/init.d/haproxyctl" do
  to "/usr/share/haproxyctl/bin/haproxyctl"
end
