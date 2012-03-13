service "networking" do
  supports :start => true, :stop => true, :restart => true
  action   :nothing
end
