gems = ["newrelic_haproxy_agent", "bundler", "fastercsv"]

gems.each do |gem|
  gem_package gem
end

backends = node["newrelic"]["haproxy"]["backends"]
frontends = node["newrelic"]["haproxy"]["frontends"]

if !backends.empty? && !frontends.empty?

  cookbook_file "/etc/init.d/newrelic-haproxy" do
    source "newrelic-haproxy"
    mode "0755"
    action :create
  end

  service "newrelic-haproxy" do
    supports [:start, :stop, :restart]
    action :nothing
  end

  template "/etc/newrelic/newrelic_haproxy_agent.yml" do
    source "newrelic_haproxy_agent.yml.erb"
    mode "0644"
    variables(
      :haproxy_user => node["haproxy"]["stats_user"],
      :haproxy_pass => node["haproxy"]["stats_password"],
      :verbose      => node["newrelic"]["plugins"]["verbose"],
      :backends     => backends,
      :frontends    => frontends,
      :license_key  => node["newrelic"]["license"],
      :url          => node["haproxy"]["stats_url"]
    )
    notifies :restart, "service[newrelic-haproxy]"
  end

end
