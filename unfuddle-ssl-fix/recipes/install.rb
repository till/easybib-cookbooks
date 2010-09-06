package "subversion"

template "/etc/ssl/certs/Equifax_Secure_Certificate_Authority.cer" do
  mode "0777"
  source "Equifax_Secure_Certificate_Authority.cer.erb"
  create_if_missing :true
end

remote_file "/root/.subversion/servers" do
  source "servers"
  mode 0755
  owner "root"
  group "root"
  create_if_missing :true
end