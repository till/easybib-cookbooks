cache_conf = node["nginx-app"]["cache"]

directory cache_conf["path"] do
  owner node["nginx-app"]["owner"]
  group node["nginx-app"]["group"]
end

template "/etc/nginx/conf.d/cache.conf" do
  source "cache.conf.erb"
  mode 0644
  variables(
    :cache_methods => cache_conf["methods"],
    :cache_path => cache_conf["path"],
    :lifetime => cache_conf["lifetime"],
    :zone => cache_conf["zone"]
  )
end
