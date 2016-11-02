package 'hping3' do
  action :install
end

cookbook_file 'HPing.pm' do
  path   '/usr/share/perl5/Smokeping/probes/HPing.pm'
  mode   '0644'
  action :create_if_missing
end

bash 'setcap hping' do
  code 'setcap cap_net_raw,cap_net_admin=eip /usr/sbin/hping3'
  user 'root'
end
