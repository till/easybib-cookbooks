if node[:opsworks]

  cluster_name = node[:opsworks][:stack][:name]

  if cluster_name == 'Fruitkid'
    template "#{node["nginx-app"][:config_dir]}/htpasswd" do
      source "htpasswd.erb"
      mode   "0640"
      owner  "root"
      group  node["nginx-app"][:group]
      variables(
        :user => node["nginx-app"][:user],
        :pass => node[:mysql][:server_root_password].crypt(cluster_name)
      )
    end
  end

end
