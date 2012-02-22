service "networking" do
  support :start => true, :stop => true, :restart => true
  action  :nothing
end
