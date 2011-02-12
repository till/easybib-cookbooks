# This recipe is used to actually configure the munin.conf, e.g. to add in hosts
# and group them 'nicely'. ;-)
# This should be run after setup, and for all configure events (when nodes in the
# cluster change.

template "/etc/munin/munin.conf" do
  mode "0644"
  source "munin.erb"
end
