template "/etc/init.d/#{node[:nodejs][:application]}" do
  source "upstart.conf.erb"
  variables({
    :application => node[:nodejs][:application],
    :user        => node[:nodejs][:user],
    :prefix      => node_prefix
  })
end

service "#{node[:nodejs][:application]}" do
  action [ :enable, :start ]
end
