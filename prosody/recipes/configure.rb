include_recipe "prosody::service"

case node[:platform]
when "debian"
when "ubuntu"
  cfg_dir = "/etc/prosody/conf.d"
else
  Chef::Log.error("Not supported: #{node[:lsb][:name]}")
end

template "#{cfg_dir}/prosody.cfg.lua" do
  owner "prosody"
  group "prosody"
  source "prosody.cfg.lua.erb"
  variables(
    :admins => node["prosody"]["admins"],
    :storage => node["prosody"]["storage"],
    :db => node["prosody"]["db"]
  )
  notifies :restart, "service[prosody]"
end
