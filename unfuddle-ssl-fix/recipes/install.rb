package "subversion"

template "/etc/ssl/certs/Equifax_Secure_Certificate_Authority.cer" do
  mode "0777"
  source "Equifax_Secure_Certificate_Authority.cer.erb"
end

execute "make installed certificate known to subversion" do
  command "echo 'ssl-authority-files = /etc/ssl/certs/Equifax_Secure_Certificate_Authority.cer' >> /etc/subversion/servers"
end