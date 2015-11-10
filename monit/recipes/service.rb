service 'monit' do
  supports :status => false, :restart => true, :reload => true
  action :nothing
end

include_recipe 'monit'
include_recipe 'monit::mailnotify'
include_recipe 'monit::systemcheck'
