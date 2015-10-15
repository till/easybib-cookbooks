template '/etc/aliases' do
  source 'aliases.erb'
  mode   '0644'
  owner  'root'
  group  'root'
  variables(
    :aliases => node['postfix']['aliases'],
    :email   => 'root'
  )
  not_if { node['sysop_email'].nil? }
end

execute 'update aliases' do
  command 'newaliases'
  not_if { node['sysop_email'].nil? }
end
