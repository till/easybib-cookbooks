gem_package "json"

require "easybib"
include_recipe "rsyslogd"

if node["loggly"] && (node["loggly"]["token"] != 'example')

  logglydata = node["loggly"]["token"]
  
  if is_aws()
    cluster_name   = get_cluster_name().gsub(/\W/,'_')
    logglydata << " tag=\\\"stack.#{cluster_name}\\\""
    get_instance_roles().each do |layer|
      layer = layer.gsub(/\W/,'_')
      logglydata << " tag=\\\"layer.#{layer}\\\""
    end
  end

  template "/etc/rsyslog.d/49-loggly.conf" do
    source "49-loggly.conf.erb"
    variables(
      :logglydata => logglydata
    )
    mode "0644"
    notifies :restart, "service[rsyslog]", :delayed
  end
  
  #clean up old location
  file "/etc/rsyslog.d/10-loggly.conf" do
    action :delete
    only_if { File.exists?('/etc/rsyslog.d/10-loggly.conf') }
  end
  
  template "/etc/rsyslog.d/11-filewatcher.conf" do
    source "11-filewatcher.conf.erb"
    mode "0644"
    notifies :restart, "service[rsyslog]", :delayed
  end
  
  cookbook_file "/etc/ssl/certs/loggly.full.pem" do
    source "loggly.full.pem"
    owner "root"
    group "root"
    mode 0644
  end

end
