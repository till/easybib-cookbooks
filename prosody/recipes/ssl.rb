ssl_dir       = "/etc/prosody/certs/"

if is_aws()
  instance_roles = get_instance_roles()
  cluster_name   = get_cluster_name()
else
  Chef::Log.debug("Not running on AWS, setting defaults.")
  instance_roles = ""
  cluster_name   = ""
end

stored_certificate = false

node[:deploy].each do |application, deploy|

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
    group     "prosody"
    recursive true
  end
  
  template ssl_dir + "/cert.pem" do
    source "ssl_key.erb"
    mode   "0640"
    owner  "root"
    group  "prosody"
    variables(
      "ssl_key" => ssl_certificate
    )
    notifies :restart, resources(:service => "prosody")
  end

  template ssl_dir + "/cert.key" do
    source "ssl_key.erb"
    mode   "0640"
    owner  "root"
    group  "prosody"
    variables(
      "ssl_key" => ssl_certificate_key
    )
    notifies :restart, resources(:service => "prosody")
  end
  
  stored_certificate = true

end

["/cert.pem", "/cert.key"].each do |f|
  if File.exists?(ssl_dir + f)
    stored_certificate = true
  end
end

if !stored_certificate
  Chef::Log.debug("No certificates were installed, we'll stop prosody.")
  service "prosody" do
    supports "status" => true, "restart" => true
    action :stop
  end
end