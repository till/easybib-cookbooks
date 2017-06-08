package_name = 'gearman-job-server'

include_recipe 'php::dependencies-ppa'
include_recipe 'ies-gearmand::service'

package package_name

template "/etc/default/#{package_name}" do
  mode   '0644'
  source 'gearmand.default.erb'
  variables(
    :port => node['ies-gearmand']['port'],
    :log  => node['ies-gearmand']['log']
  )
  notifies :restart, "service[#{package_name}]", :immediate
end
