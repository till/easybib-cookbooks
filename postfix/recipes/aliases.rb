template '/etc/aliases' do
  source 'aliases.erb'
  mode   '0644'
  owner  'root'
  group  'root'
  variables(
    :aliases => node['postfix']['aliases'],
    :sysop_email => node['sysop_email']
  )
  not_if { node['sysop_email'].nil? }
end

execute 'update aliases' do
  command 'newaliases'
  not_if { node['sysop_email'].nil? }
end
