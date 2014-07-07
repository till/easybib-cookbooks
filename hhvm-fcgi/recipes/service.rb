service_name = "hhvm"

service "hhvm" do
  service_name service_name
  supports     [:start, :stop, :reload, :restart]
  action       :nothing
end
