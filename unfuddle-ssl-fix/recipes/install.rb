package "subversion"

template "/etc/ssl/certs/Equifax_Secure_Certificate_Authority.cer" do
  mode "0777"
  source "Equifax_Secure_Certificate_Authority.cer.erb"
  not_if "test -f /etc/ssl/certs/Equifax_Secure_Certificate_Authority.cer"
end

users = %w[ root www-data ]

users.each do |user|

  case user
  when 'root'
    home_dir = "/root"
  when 'www-data'
    home_dir = "/var/www"
  else
    home_dir = "/home/#{user}"
  end

  directory "#{home_dir}/.subversion" do
    owner user
    mode "0755"
    action :create
  end

  remote_file "#{home_dir}/.subversion/servers" do
    source "servers"
    mode 0755
    owner user
  end

end
