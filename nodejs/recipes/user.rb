if node[:nodejs][:user] != "root" 

  group "#{node[:nodejs][:user]}" do
    gid 31337
  end

  user "#{node[:nodejs][:user]}" do
    comment "user to run node"
    gid 31337
    home "/srv/www/#{node[:nodejs][:application]}"
    shell "/bin/false"
    action :create
  end
end
