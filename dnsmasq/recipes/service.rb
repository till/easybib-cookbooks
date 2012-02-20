service "dnsmasq" do
  supports :start => true, :stop => true, :restart => true, :status => true
  action   :nothing
end
