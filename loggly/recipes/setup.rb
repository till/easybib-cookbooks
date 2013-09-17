gem_package "json"

if node["loggly"] && (node["loggly"]["domain"] != 'example')

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

  if is_aws()

    instance = get_instance()

    template "/etc/init.d/loggly" do
      source "loggly.sh.erb"
      mode "0755"
      variables({
        :instance => instance
      })
    end
  end

  include_recipe "loggly::scalarium"
  include_recipe "loggly::service"

end
