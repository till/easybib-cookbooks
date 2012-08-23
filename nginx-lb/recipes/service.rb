service "nginx" do
  supports "status" => true, "restart" => true
  action :nothing
end
