include_recipe 'nginx-lb::default'
include_recipe 'nginx-lb::service'

right_role    = node["nginx-lb"]["role"]
right_cluster = node["nginx-lb"]["cluster"]
nginx_dir     = node["nginx-lb"]["dir"]
ssl_dir       = node["ssl-deploy"]["directory"]
int_ip        = node["nginx-lb"]["int_ip"]

if is_aws()
  instance_roles = get_instance_roles()
  cluster_name   = get_cluster_name()
else
  Chef::Log.debug("Not running on AWS, setting defaults.")
  instance_roles = ""
  cluster_name   = ""
end

stored_certificate = false

node["deploy"].each do |application, deploy|

  next unless deploy["deploying_user"]

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
    Chef::Log.info("No ssl_certificate 'key'")
    next
  end

  if !deploy.has_key?("ssl_certificate_key")
    Chef::Log.info("No ssl_certificate_key 'key'")
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

  ssl_certificate     = deploy["ssl_certificate"].chomp
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
    notifies :restart, "service[nginx]"
  end

  template ssl_dir + "/cert.key" do
    source "ssl_key.erb"
    mode   "0640"
    owner  "root"
    group  "www-data"
    variables(
      "ssl_key" => ssl_certificate_key
    )
    notifies :restart, "service[nginx]"
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
    notifies :restart, "service[nginx]"
  end

  stored_certificate = true

end

["/cert.pem", "/cert.key"].each do |f|
  if File.exists?(ssl_dir + f)
    stored_certificate = true
  end
end

if !stored_certificate
  Chef::Log.debug("No certificates were installed, we'll stop nginx.")
  service "nginx" do
    supports "status" => true, "restart" => true
    action :stop
  end
end
