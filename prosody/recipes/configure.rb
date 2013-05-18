include_recipe "prosody::service"

case node[:platform]
when "debian"
when "ubuntu"
  cfg_dir = "/etc/prosody/conf.d"
else
  Chef::Log.error("Not supported: #{node[:lsb][:name]}")
end

if node["prosody"]["storage"] == "sql"

  db_conf = node["prosody"]["db"]

  mysql_command = "mysql -u %s -h %s" % [ db_conf["username"], db_conf["hostname"] ]
  if !db_conf["password"].empty?
    mysql_command += " -p #{db_conf["password"]}"
  end

  execute "create database '#{db_conf["database"]} for prosody" do
    command "#{mysql_command} -e \"CREATE DATABASE IF NOT EXISTS #{db_conf["database"]}\""
  end

end

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
