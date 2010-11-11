service "elb" do
  supports :status => true, :start => true, :stop => true
  action [ :enable, :start ]
end
