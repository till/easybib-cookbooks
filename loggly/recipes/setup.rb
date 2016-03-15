gem_package 'json'

include_recipe 'rsyslogd'

if node['loggly']['token'] != 'example'

  logglydata = node['loggly']['token']

  ca_file = node['loggly']['ca_file']

  if is_aws
    cluster_name   = get_cluster_name.gsub(/\W/, '_')
    logglydata << " tag=\\\"stack.#{cluster_name}\\\""
    get_instance_roles.each do |layer|
      layer = layer.gsub(/\W/, '_')
      logglydata << " tag=\\\"layer.#{layer}\\\""
    end
  end

  template '/etc/rsyslog.d/49-loggly.conf' do
    source '49-loggly.conf.erb'
    variables(
      :logglydata => logglydata,
      :ca_file => ca_file
    )
    mode '0644'
    notifies :restart, 'service[rsyslog]', :delayed
  end

  # clean up old location
  file '/etc/rsyslog.d/10-loggly.conf' do
    action :delete
    only_if { File.exist?('/etc/rsyslog.d/10-loggly.conf') }
  end

  # old ssl certificate
  old_ca_file = '/etc/ssl/certs/loggly.full.pem'
  file old_ca_file do
    action :delete
    only_if do
      File.exist?(old_ca_file)
    end
  end

  template '/etc/rsyslog.d/11-filewatcher.conf' do
    source '11-filewatcher.conf.erb'
    mode '0644'
    notifies :restart, 'service[rsyslog]', :delayed
  end

  package 'rsyslog-gnutls'

  cookbook_file ca_file do
    source File.basename(ca_file)
    owner 'root'
    group 'root'
    mode 0644
    notifies :restart, 'service[rsyslog]', :delayed
  end

end
