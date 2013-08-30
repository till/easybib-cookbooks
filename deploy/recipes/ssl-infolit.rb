right_role = "nginxphpapp"
ssl_dir    = node["ssl-deploy"]["directory"]

if is_aws
  instance_roles = get_instance_roles()
  cluster_name   = get_cluster_name()
else
  Chef::Log.debug("Not running in scalarium, setting defaults.")
  instance_roles = ""
  cluster_name   = ""
end

stored_certificate = false

node["deploy"].each do |application, deploy|

  next unless deploy["deploying_user"]

  if cluster_name != node["easybib"]["cluster_name"]
    next
  end

  if application != "ssl"
    next
  end

  if !instance_roles.include?(right_role)
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
  end

  template ssl_dir + "/cert.key" do
    source "ssl_key.erb"
    mode   "0640"
    owner  "root"
    group  "www-data"
    variables(
      "ssl_key" => ssl_certificate_key
    )
  end

end
