# This recipe is used to actually configure the munin.conf, e.g. to add in hosts
# and group them 'nicely'. ;-)
# This should be run after setup, and for all configure events (when nodes in the
# cluster change.

directory node[:munin][:log_dir] do
  owner  node[:munin][:user]
  group  node[:munin][:group]
  action :create
end

template "/etc/munin/munin.conf" do
  mode "0644"
  source "munin.erb"
end

# this is for cgi
if node[:munin][:graph] == 'cgi'
  execute "touch #{node[:munin][:log_dir]}/munin-cgi-graph.log" do
    not_if do File.exits?("#{node[:munin][:log_dir]}/munin-cgi-graph.log") end
  end

  # require so the graph cgi can read and write
  execute "chgrp www-data /usr/share/munin/munin-graph"
  execute "chgrp www-data #{node[:munin][:log_dir]} #{node[:munin][:log_dir]}/munin-graph.log #{node[:munin][:log_dir]}/munin-cgi-graph.log"
  execute "chmod g+w #{node[:munin][:log_dir]} #{node[:munin][:log_dir]}/munin-graph.log #{node[:munin][:log_dir]}/munin-cgi-graph.log"
  execute "chgrp -R www-data #{node[:munin][:www_dir]}"
  execute "chmod -R g+w #{node[:munin][:www_dir]}"
end
