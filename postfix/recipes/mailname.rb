# fix this for Ubuntu
if node[:scalarium]
  my_hostname = node[:scalarium][:instance][:hostname]
else
  my_hostname = node[:hostname]
end

template "/etc/mailname" do
  source "mailname.erb"
  variables(
    :my_hostname => my_hostname
  )
end
