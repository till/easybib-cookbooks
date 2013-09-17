ssl_dir = "/etc/prosody/certs/"

stored_certificate = false

if is_aws()
  instance_roles = get_instance_roles()
  cluster_name   = get_cluster_name()
else
  Chef::Log.debug("Not running on AWS, setting defaults.")
  instance_roles = ""
  cluster_name   = ""
end

node["deploy"].each do |application, deploy|

  Chef::Log.info("prosody::ssl - request to deploy for: #{application}, role: #{instance_roles} in #{cluster_name}")

  next unless cluster_name == node["easybib"]["cluster_name"]

  case application
  when 'jabber'
    next unless instance_roles.include?('jabber')
  else
    Chef::Log.info("prosody::ssl - #{application} (in #{cluster_name}) skipped, is not application jabber")
    next
  end

  Chef::Log.info("prosody::ssl - ssl key installation started")

  if !deploy.has_key?("ssl_certificate")
    Chef::Log.info("No ssl_certificate 'key'")
    next
  end

  if !deploy.has_key?("ssl_certificate_key")
    Chef::Log.info("No ssl_certificate_key 'key'")
    next
  end

  if deploy["ssl_certificate"].nil?
    Chef::Log.error("ssl_certificate is nil")
    next
  end

  if deploy["ssl_certificate_key"].nil?
    Chef::Log.error("ssl_certificate_key is nil")
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
    notifies :restart, "service[prosody]"
  end

  template ssl_dir + "/cert.key" do
    source "ssl_key.erb"
    mode   "0640"
    owner  "root"
    group  "prosody"
    variables(
      "ssl_key" => ssl_certificate_key
    )
    notifies :restart, "service[prosody]"
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
