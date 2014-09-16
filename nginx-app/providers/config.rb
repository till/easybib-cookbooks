action :create do

  nginx_config_cookbook = new_resource.cookbook
  nginx_config_template = new_resource.template

  nginx_user = new_resource.nginx_user || node["nginx-app"]["user"]
  nginx_group = new_resource.nginx_group || node["nginx-app"]["group"]
  enable_fastcgi = new_resource.enable_fastcgi

  # this is a hack to maximize - currently only
  # in use in nginx-lb
  if node["cpu"]["total"] > 1
    processes = (node["cpu"]["total"]) - 1
  else
    processes = 1
  end

  template "/etc/nginx/fastcgi_params" do
    cookbook "nginx-app"
    source "fastcgi_params.erb"
    mode "0755"
    owner nginx_user
    group nginx_group
    only_if { new_resource.enable_fastcgi }
  end

  template "/etc/nginx/nginx.conf" do
    source nginx_config_template
    cookbook nginx_config_cookbook
    mode "0644"
    owner nginx_user
    group nginx_group
    variables(
      :nginx_user => nginx_user,
      :processes => processes
    )
  end

  execute "delete default vhost" do
    ignore_failure true
    command "rm -f /etc/nginx/sites-enabled/default"
    only_if { new_resource.delete_default }
  end

end

action :delete do
  file "/etc/nginx/nginx.conf" do
    action :delete
    only_if do
      File.exists?("/etc/nginx/nginx.conf")
    end
  end
end
