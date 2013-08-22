include_recipe "prosody::service"

case node["platform"]
when "debian", "ubuntu"
  cfg_partial_dir = "/etc/prosody/conf.d"
  cfg_dir = "/etc/prosody"
else
  Chef::Log.error("Not supported: #{node["lsb"]["name"]}")
end

include_recipe "prosody::storage"

template "#{cfg_dir}/prosody.cfg.lua" do
  owner "prosody"
  group "prosody"
  source "prosody.cfg.main.lua.erb"
  variables(
    :include_files => "#{cfg_partial_dir}/*.cfg.lua"
  )
  notifies :restart, resources( :service => "prosody")
end

template "#{cfg_partial_dir}/prosody.cfg.lua" do
  owner "prosody"
  group "prosody"
  source "prosody.cfg.lua.erb"
  variables(
    :admins => node["prosody"]["admins"],
    :storage => node["prosody"]["storage"],
    :db => node["prosody"]["db"],
    :domains => node["prosody"]["domains"]
  )
  notifies :restart, resources( :service => "prosody")
end

include_recipe "prosody::ssl"
include_recipe "prosody::users"
