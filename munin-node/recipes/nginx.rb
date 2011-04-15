munin_plugins = ["nginx_status", "nginx_request", "nginx_memory"]

directory "/opt/munin-nginx" do
  mode "0755"
end

munin_plugins.each do |plugin|

  cookbook_file "/opt/munin-nginx/#{plugin}" do
    source "#{plugin}"
    mode "0755"
  end

  link "/etc/munin/plugins/#{plugin}" do
    to "/opt/munin-nginx/#{plugin}"
  end
end
