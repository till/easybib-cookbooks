include_recipe "subversion"

template "/etc/ssl/certs/Equifax_Secure_Certificate_Authority.cer" do
  mode "0777"
  source "Equifax_Secure_Certificate_Authority.cer.erb"
  not_if "test -f /etc/ssl/certs/Equifax_Secure_Certificate_Authority.cer"
end
