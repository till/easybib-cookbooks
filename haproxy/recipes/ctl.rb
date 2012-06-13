git "/usr/share/haproxyctl" do
  repository "git://github.com/flores/haproxyctl.git"
  reference "0.1.0"
  action :sync
end

link "/usr/share/haproxyctl/bin/haproxyctl" do
  to "/etc/init.d/haproxyctl"
end
