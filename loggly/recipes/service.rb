service "loggly" do
  supports :start => true, :stop => true
  running false
  action [ :enable, :start ]
end
