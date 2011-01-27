munin_plugins = ["nginx_status", "nginx_requests"]

munin_plugins.each do |plugin|
  link "/etc/munin/plugins/#{plugin}" do
    to "/usr/share/munin/plugins/#{plugin}"
  end
end
