instance_roles = get_instance_roles()
cluster_name   = get_cluster_name()

node[:deploy].each do |application, deploy|

  Chef::Log.info("deploy::jabber - request to deploy app: #{application}, role: #{instance_roles} in #{cluster_name}")

  next unless cluster_name == node["easybib"]["cluster_name"]

  case application
  when 'jabber'
    next unless instance_roles.include?('jabber')
  else
    Chef::Log.info("deploy::jabber - #{application} (in #{cluster_name}) skipped")
    next
  end

  Chef::Log.info("deploy::jabber - Deployment started.")

  include_recipe "prosody::default"

end
