gem_pagkage "json"

if node[:loggly] && (node[:loggly][:domain] != 'example')
  template "/etc/rsyslog.d/10-loggly.conf" do
    source "10-loggly.conf.erb"
    mode "0644"
  end

  service "rsyslog" do
    supports :status => true, :restart => true, :reload => true
    action [ :restart ]
  end
  
  cookbook_file "/usr/local/bin/deviceid" do
    source "deviceid"
    mode "0755"
  end

  template "/etc/init.d/loggly" do
    source "loggly.sh.erb"
    mode "0755"
  end
end

if node[:scalarium]
  if node[:scalarium][:instance][:roles].include?('loadbalancer')

    template "/etc/rsyslog.d/10-haproxy.conf" do
      source "10-haproxy.conf.erb"
      mode "0644"
    end

    directory "#{node[:syslog][:haproxy][:log_dir]}" do
      recursive true
      mode "0755"
    end

    service "rsyslog" do
      supports :status => true, :restart => true, :reload => true
      action [ :restart ]
    end
  end
end

service "loggly" do
  supports :start => true, :stop => true
  running false
  action [ :enable, :start ]
end
