if node[:server_name]
  execute "set servername" do
    command "echo #{node[:server_name] > /etc/hostname"
  end
end
