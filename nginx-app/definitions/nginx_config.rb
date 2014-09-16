define :nginx_config,
  :enable_fastcgi => true, :delete_default => true, :cookbook => "nginx-app",
  :template => "nginx.conf.erb", :nginx_user => nil, :nginx_group => nil,
  :service_action => :start do

  nginx_config_cookbook = params[:cookbook]
  nginx_config_template = params[:template]

  params[:nginx_user] ||= node["nginx-app"]["user"]
  params[:nginx_group] ||= node["nginx-app"]["group"]

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
    owner params[:nginx_user]
    group params[:nginx_group]
    only_if { params[:enable_fastcgi] }
  end

  template "/etc/nginx/nginx.conf" do
    source nginx_config_template
    cookbook nginx_config_cookbook
    mode "0644"
    owner params[:nginx_user]
    group params[:nginx_group]
    variables(
      :nginx_user => params[:nginx_user],
      :processes => processes
    )
    notifies params[:service_action], "service[nginx]"
  end

  execute "delete default vhost" do
    ignore_failure true
    command "rm -f /etc/nginx/sites-enabled/default"
    only_if { params[:delete_default] }
  end

end
