package "munin"

directory "#{node[:munin][:libdir]}" do
  owner     'munin'
  group     'munin'
  mode      '0755'
  action    :create
  recursive true
end

if File.directory?("/etc/apache2") 
  include_recipe "munin::apache2"
else
  Chef::Log.debug("Apache2 is not installed, might need to fix that.")
end
