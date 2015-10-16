ips         = ['127.0.0.0/8']
etc_path    = '/etc/postfix'
my_hostname = get_hostname(node)

if is_aws
  instance = get_instance
  ips.push(instance['ip'])
  ips.push(instance['private_ip'])
end

rewrite_address = node['postfix']['rewrite_address'] && !node['sysop_email'].nil?

if node['postfix']['relay']['host'].nil?
  relay_host = node['postfix']['relay']['host']
else
  relay_host = node['postfix']['relay']['full_host']
end

# install main.cf
template "#{etc_path}/main.cf" do
  owner  'postfix'
  group  'postfix'
  mode   '0644'
  source 'main.cf.erb'
  variables(
    :etc_path       => etc_path,
    :ips            => ips,
    :my_hostname    => my_hostname,
    :relay_host     => relay_host,
    :my_destination => my_hostname,
    :rewrite_address => rewrite_address
  )
end

# setup passwd
template "#{etc_path}/sasl/passwd" do
  source 'passwd.erb'
  mode   '0600'
  variables(
    :relay => [node['postfix']['relay']]
  )
  not_if { relay_host.nil? }
end

execute 'postmap' do
  command "postmap #{etc_path}/sasl/passwd"
  not_if { relay_host.nil? }
end

if rewrite_address
  template "#{etc_path}/sender_canonical_maps" do
    source 'sender_canonical_maps.erb'
    mode   '0600'
    variables(
      :address => node['sysop_email']
    )
  end
  template "#{etc_path}/header_check" do
    source 'header_check.erb'
    mode   '0600'
    variables(
      :address => node['sysop_email']
    )
  end
end

service 'postfix' do
  supports :status => true, :restart => true, :reload => true, :check => true
  action [:enable, :reload]
end
