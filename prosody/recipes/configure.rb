include_recipe "prosody::service"

prosody_dirs = []
prosody_dirs.push("/var/prosody")

case node["platform"]
when "debian", "ubuntu"
  cfg_partial_dir = "/etc/prosody/conf.d"
  cfg_dir = "/etc/prosody"

  prosody_dirs.push(cfg_partial_dir)
  prosody_dirs.push(cfg_dir)
else
  Chef::Log.error("Not supported: #{node["lsb"]["name"]}")
end

prosody_dirs.each do |dir|
  directory dir do
    owner "prosody"
    group "prosody"
    mode "0755"
    recursive true
  end
end

include_recipe "prosody::storage"

template "#{cfg_dir}/prosody.cfg.lua" do
  owner "prosody"
  group "prosody"
  source "prosody.cfg.main.lua.erb"
  variables(
    :include_files => "#{cfg_partial_dir}/*.cfg.lua"
  )
  notifies :restart, "service[prosody]"
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
  notifies :restart, "service[prosody]"
end

include_recipe "prosody::ssl"
include_recipe "prosody::users"
