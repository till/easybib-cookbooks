right_role = node["nginx-lb"]["role"]
right_cluster = node["nginx-lb"]["cluster"]
ssl_dir = node["nginx-lb"]["dir"]
int_ip = node["nginx-lb"]["int_ip"]

instance_roles = node[:scalarium][:instance][:roles]
cluster_name = node[:scalarium][:cluster][:name]

node[:deploy].each do |application, deploy|

  if application != "ssl"
    next
  end

  if instance_roles.to_s != right_role
    next
  end

  if cluster_name.to_s != right_cluster
    next
  end

  if !deploy.has_key?("ssl_certificate")
    next
  end

  if !deploy.has_key?("ssl_certificate_key")
    next
  end

  if deploy["ssl_certificate"].empty?
    Chef::Log.debug("ssl_certificate is empty")
    next
  end

  if deploy["ssl_certificate_key"].empty?
    Chef::Log.debug("ssl_certificate_key is empty")
    next
  end

  ssl_certificate = deploy["ssl_certificate"].chomp
  ssl_certificate_key = deploy["ssl_certificate_key"].chomp

  template ssl_dir + "/cert.pem" do
    source "ssl_key.erb"
    mode   "0640"
    owner  "root"
    group  "www-data"
    variables(
      "ssl_key" => ssl_certificate
    )
    notifies :start, resources(:service => "nginx")
  end

  template ssl_dir + "/cert.key" do
    source "ssl_key.erb"
    mode   "0640"
    owner  "root"
    group  "www-data"
    variables(
      "ssl_key" => ssl_certificate_key
    )
    notifies :start, resources(:service => "nginx")
  end

  template ssl_dir + "/sites-enabled/easybib-ssl.conf" do
    source "nginx.conf.erb"
    mode   "0644"
    owner  "root"
    group  "root"
    variables(
      "ssl_dir" => ssl_dir,
      "int_ip"  => int_ip
    )
    notifies :start, resources(:service => "nginx")
  end

  file ssl_dir + "/sites-enabled/default" do
    action :delete
  end

end
