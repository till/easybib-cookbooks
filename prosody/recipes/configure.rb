include_recipe "prosody::service"

case node[:platform]
when "debian"
when "ubuntu"
  cfg_dir = "/etc/prosody/conf.d"
else
  Chef::Log.error("Not supported: #{node[:lsb][:name]}")
end

include_recipe "prosody::storage"

template "#{cfg_dir}/prosody.cfg.lua" do
  owner "prosody"
  group "prosody"
  source "prosody.cfg.lua.erb"
  variables(
    :admins => node["prosody"]["admins"],
    :storage => node["prosody"]["storage"],
    :db => node["prosody"]["db"],
    :domains => node["prosody"]["domains"]
  )
  notifies :reload, "service[prosody]"
end

include_recipe "prosody::users"
