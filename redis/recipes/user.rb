if node[:redis][:user] != 'root'
  user "#{node[:redis][:user]}" do
    shell  "/bin/zsh"
    action :create
  end
end
