base = node["librato"]["statsd"]["etc_dir"]

directory base do
  mode  "0755"
  owner node["librato"]["statsd"]["user"]
  group node["librato"]["statsd"]["group"]
end

cluster_name = get_cluster_name().gsub(/\s+/, '-')

template "#{base}/config.js" do
  source "easybib-config.js.erb"
  mode   "0600"
  owner  node["librato"]["statsd"]["user"]
  group  node["librato"]["statsd"]["group"]
  variables({
    :statsd => node["librato"]["statsd"],
    :metrics => node["librato"]["metrics"],
    :cluster_name => cluster_name
  })
end
