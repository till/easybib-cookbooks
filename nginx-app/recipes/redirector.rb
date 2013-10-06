include_recipe "nginx-app::service"

node["redirector"]["domains"].each do |domain_name, new_domain_name|

  template "/etc/nginx/sites-enabled/redir-#{domain_name}.conf" do
    source "redirect.conf.erb"
    mode   "0755"
    owner  node["nginx-app"]["user"]
    group  node["nginx-app"]["group"]
    variables(
      :domain_name => domain_name,
      :new_domain_name => new_domain_name
    )
    notifies :restart, "service[nginx]", :delayed
  end

end
