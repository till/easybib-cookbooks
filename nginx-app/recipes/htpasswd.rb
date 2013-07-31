cluster_name = get_cluster_name()
is_aws = is_aws()

template "#{node["nginx-app"]["config_dir"]}/htpasswd" do
  source "htpasswd.erb"
  mode   "0640"
  owner  "root"
  group  node["nginx-app"]["group"]
  variables(
    :user => node["nginx-app"]["user"],
    :pass => node["mysql"]["server_root_password"].crypt(cluster_name)
  )
  only_if do
    is_aws && cluster_name == 'Fruitkid'
  end
end
