dir_version  = node[:nodejs][:version].gsub('.', '')
node_prefix  = "/usr/local/node#{dir_version}"

template "/etc/init.d/#{node[:nodejs][:application]}" do
  source "upstart.conf.erb"
  variables({
    :application => node[:nodejs][:application],
    :user        => node[:nodejs][:user],
    :prefix      => node_prefix
  })
end

file "/var/log/#{node[:nodejs][:application]}.log" do
  user "#{node[:nodejs][:user]}"
  mode "0644"
end

service "#{node[:nodejs][:application]}" do
  action [ :enable, :start ]
end
