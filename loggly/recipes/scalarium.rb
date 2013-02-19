# this is specific to our setup and is only triggered on scalarium
if node[:opsworks]
  if node[:opsworks][:instance][:layers].include?('loadbalancer')

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
