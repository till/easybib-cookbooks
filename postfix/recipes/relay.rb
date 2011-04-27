require 'resolv'

ips = ['127.0.0.0/8']

if node[:scalarium]
  ips.push(node[:scalarium][:instance][:ip])
  ips.push(Resolv.getaddress(node[:scalarium][:instance][:private_dns_name]))

  my_hostname = node[:scalarium][:instance][:hostname]
else
  my_hostname = 'horst'
end

relay_host = node[:postfix][:relay][0]["host"]

etc_path = "/etc/postfix"

# install main.cf
template "#{etc_path}/main.cf" do
  source "main.cf.erb"
  variables(
    :etc_path    => etc_path,
    :ips         => ips,
    :my_hostname => my_hostname,
    :relay_host  => relay_host
  )
end

# setup passwd
template "#{etc_path}/sasl/passwd" do
  source "passwd.erb"
  mode   "0600"
end

execute "postmap" do
  command "postmap #{etc_path}/sasl/passwd"
end

service "postfix" do
  supports :status => true, :restart => true, :reload => true, :check => true, :reload => true
  action [ :enable, :reload ]
end
