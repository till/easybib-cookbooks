service "prosody" do
  action :nothing
  supports [ :start, :stop, :restart, :reload ]
end
