include_recipe "avahi::alias-service"

if node.fetch('vagrant', {})['applications'].nil?
  domains = node["getcourse"]["domain"]
else
  domains = []
  node["vagrant"]["applications"].each do |app_name, app_config|
    app_config['domain_name'].split(' ').each do |domain|
      domains << domain
    end
  end
end

template "/etc/avahi/aliases.d/getcourse" do
  cookbook "avahi"
  source "alias.erb"
  mode "0644"
  variables(
    :domains => node["getcourse"]["domain"]
  )
  notifies :restart, "service[avahi-aliases]"
end
