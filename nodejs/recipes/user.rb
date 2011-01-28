user "#{node[:nodejs][:user]}" do
  comment "user to run node"
  home "/var/www"
  shell "/bin/false"
  action :create
end
