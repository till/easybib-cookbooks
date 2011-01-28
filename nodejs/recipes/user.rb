user "#{node[:nodejs][:user]}" do
  comment "user to run node"
  system true
  shell "/bin/false"
end
