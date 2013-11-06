gem_package "json"

if node["loggly"] && (node["loggly"]["domain"] != 'example')

  logglydata = node["loggly"]["token"]
  
  if is_aws()
    cluster_name   = get_cluster_name().gsub(/\W/,'_')
    logglydata << " tag=\\\"stack.#{cluster_name}\\\""
    get_instance_roles().each do |layer|
      layer = layer.gsub(/\W/,'_')
      logglydata << " tag=\\\"layer.#{layer}\\\""
    end
  end

  template "/etc/rsyslog.d/10-loggly.conf" do
    source "10-loggly.conf.erb"
    variables(
      :logglydata => logglydata
    )
    mode "0644"
  end

  service "rsyslog" do
    supports :status => true, :restart => true, :reload => true
    action [ :restart ]
  end


  include_recipe "loggly::opsworks"

end
