# fix this for Ubuntu
if !get_cluster_name.empty?
  instance    = get_instance()
  my_hostname = instance["hostname"]
else
  # node.json
  if node["server_name"]
    my_hostname = node["server_name"]
  # from 'ohai'
  else
    my_hostname = node["hostname"]
  end
end

template "/etc/mailname" do
  mode   "0644"
  source "mailname.erb"
  variables(
    :my_hostname => my_hostname
  )
end
