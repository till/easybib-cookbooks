require 'resolv'

ips = ['127.0.0.0/8']

if !get_cluster_name().empty?

  instance = get_instance()

  ips.push(instance["ip"])
  ips.push(Resolv.getaddress(instance["private_dns_name"]))

  my_hostname = instance["hostname"]
else
  my_hostname = node["hostname"]
end

relay_host = node["postfix"]["relay"][0]["host"]

etc_path = "/etc/postfix"

# install main.cf
template "#{etc_path}/main.cf" do
  owner  "postfix"
  group  "postfix"
  mode   "0644"
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
