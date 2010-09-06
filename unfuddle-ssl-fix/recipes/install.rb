package "subversion"

template "/etc/ssl/certs/Equifax_Secure_Certificate_Authority.cer" do
  mode "0777"
  source "Equifax_Secure_Certificate_Authority.cer.erb"
  not_if "test -f /etc/ssl/certs/Equifax_Secure_Certificate_Authority.cer"
end

directory "/root/.subversion" do
  owner "root"
  group "root"
  mode "0755"
  action :create
end

remote_file "/root/.subversion/servers" do
  source "servers"
  mode 0755
  owner "root"
  group "root"
end