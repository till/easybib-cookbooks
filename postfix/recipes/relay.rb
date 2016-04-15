include_recipe 'postfix::service'

ips         = ['127.0.0.0/8']
etc_path    = '/etc/postfix'
my_hostname = get_hostname(node)

if is_aws
  instance = get_instance
  ips.push(instance['ip'])
  ips.push(instance['private_ip'])
end

rewrite_address = node['postfix']['rewrite_address'] && !node['sysop_email'].nil?

relay_host = if node['postfix']['relay']['full_host'].nil?
               node['postfix']['relay']['host']
             else
               node['postfix']['relay']['full_host']
             end

# install main.cf
my_destination = [
  my_hostname,
  "#{my_hostname}.localdomain",
  'localhost.localdomain',
  'localhost'
]

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
    :my_destination => my_destination,
    :rewrite_address => rewrite_address
  )
  notifies :reload, 'service[postfix]', :delayed
end

# setup passwd
execute 'postmap' do
  command "postmap #{etc_path}/sasl/passwd"
  action :nothing
end

template "#{etc_path}/sasl/passwd" do
  source 'passwd.erb'
  mode   '0600'
  variables(
    :relay => [node['postfix']['relay']]
  )
  not_if { relay_host.nil? }
  notifies :run, 'execute[postmap]'
  notifies :reload, 'service[postfix]', :delayed
end

if rewrite_address
  template "#{etc_path}/sender_canonical_maps" do
    source 'sender_canonical_maps.erb'
    mode   '0600'
    variables(
      :address => node['sysop_email']
    )
    notifies :reload, 'service[postfix]', :delayed
  end

  template "#{etc_path}/header_check" do
    source 'header_check.erb'
    mode   '0600'
    variables(
      :address => node['sysop_email']
    )
    notifies :reload, 'service[postfix]', :delayed
  end

  execute 'postmap-generic' do
    command "postmap #{etc_path}/generic"
    action :nothing
  end

  template "#{etc_path}/generic" do
    source 'generic.erb'
    variables(
      :address => node['sysop_email'],
      :my_destination => my_destination
    )
    notifies :run, 'execute[postmap-generic]'
    notifies :reload, 'service[postfix]', :delayed
  end
end
