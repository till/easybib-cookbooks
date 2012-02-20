service "dnsmasq" do
  supports :start => true, :stop => true, :restart => true, :force-reload => true, :status => true
  action   :nothing
end
