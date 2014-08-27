include_recipe "percona::server"
include_recipe "php-xdebug"
include_recipe "avahi"
include_recipe "avahi::alias"
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
    :domains => domains
  )
  notifies :restart, "service[avahi-aliases]"
end

include_recipe "nodejs"
include_recipe "zsh::configure"
include_recipe "redis"
include_recipe "memcache"
