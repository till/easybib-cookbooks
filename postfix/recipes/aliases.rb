template "/etc/aliases" do
  source "aliases.erb"
  mode   "0644"
  owner  "root"
  group  "root"
  variables(
    :aliases => node["postfix"]["aliases"],
    :email   => node["sysop_email"]
  )
end

execute "update aliases" do
  command "newaliases"
end
