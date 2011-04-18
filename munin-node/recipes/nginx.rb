munin_plugins = ["nginx_status", "nginx_request", "nginx_memory"]

# plugin_dir
plugin_dir = "/opt/munin-nginx"

directory "#{plugin_dir}" do
  mode "0755"
end

munin_plugins.each do |plugin|

  cookbook_file "#{plugin_dir}/#{plugin}" do
    source "#{plugin}"
    mode   "0755"
  end

  link "/etc/munin/plugins/#{plugin}" do
    to "#{plugin_dir}/#{plugin}"
  end

end
