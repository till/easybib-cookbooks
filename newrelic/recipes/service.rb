service_name = "newrelic-sysmond"

service "newrelic-sysmond" do
  service_name service_name
  supports     [:start, :stop, :restart]
end
