include_recipe 'nginx-lb::default'
include_recipe 'nginx-lb::service'

right_role    = node["nginx-lb"]["role"]
right_cluster = node["nginx-lb"]["cluster"]
nginx_dir     = node["nginx-lb"]["dir"]
ssl_dir       = nginx_dir + "/ssl"
int_ip        = node["nginx-lb"]["int_ip"]

if node.attribute?(:scalarium)
  instance_roles = node[:scalarium][:instance][:roles]
  cluster_name   = node[:scalarium][:cluster][:name]
else
  Chef::Log.debug("Not running in scalarium, setting defaults.")
  instance_roles = ""
  cluster_name   = ""
end

stored_certificate = false

node[:deploy].each do |application, deploy|

  if application != "ssl"
    next
  end

  if !instance_roles.include?(right_role)
    next
  end

  if !right_cluster.include?(cluster_name.to_s)
    Chef::Log.info("Will not deploy to: " + cluster_name.to_s)
    next
  end

  if !deploy.has_key?("ssl_certificate")
    next
  end

  if !deploy.has_key?("ssl_certificate_key")
    next
  end

  if deploy["ssl_certificate"].empty?
    Chef::Log.error("ssl_certificate is empty")
    next
  end

  if deploy["ssl_certificate_key"].empty?
    Chef::Log.error("ssl_certificate_key is empty")
    next
  end

  ssl_certificate = deploy["ssl_certificate"].chomp
  ssl_certificate_key = deploy["ssl_certificate_key"].chomp

  directory ssl_dir do
    mode      "0750"
    owner     "root"
    group     "www-data"
    recursive true
  end

  template ssl_dir + "/cert.pem" do
    source "ssl_key.erb"
    mode   "0640"
    owner  "root"
    group  "www-data"
    variables(
      "ssl_key" => ssl_certificate
    )
    notifies :restart, resources(:service => "nginx")
  end

  template ssl_dir + "/cert.key" do
    source "ssl_key.erb"
    mode   "0640"
    owner  "root"
    group  "www-data"
    variables(
      "ssl_key" => ssl_certificate_key
    )
    notifies :restart, resources(:service => "nginx")
  end

  template nginx_dir + "/sites-enabled/easybib-ssl.conf" do
    source "nginx-ssl.conf.erb"
    mode   "0644"
    owner  "root"
    group  "root"
    variables(
      "ssl_dir" => ssl_dir,
      "int_ip"  => int_ip,
      "domains" => deploy["domains"]
    )
    notifies :restart, resources(:service => "nginx")
  end

  file nginx_dir + "/sites-enabled/default" do
    action :delete
    only_if do
      File.exists?(nginx_dir + "/sites-enabled/default")
    end
  end

  stored_certificate = true

end

if !stored_certificate
  Chef::Log.debug("No certificates were installed, we'll stop nginx.")
  service "nginx" do
    supports "status" => true, "restart" => true
    action :stop
  end
end
