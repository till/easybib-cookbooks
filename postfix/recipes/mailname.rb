Chef::Resource.send(:include, EasyBib)

template '/etc/mailname' do
  mode   '0644'
  source 'mailname.erb'
  variables(
    :my_hostname => get_hostname(node)
  )
end
