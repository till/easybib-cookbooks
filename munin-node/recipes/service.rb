# include this from all recipies in munin-node

service "munin-node" do
  supports :restart => true, :reload => true, :start => true, :stop => true
  action [ :enable, :restart ]
end
