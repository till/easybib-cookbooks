package 'nscd'

service 'nscd' do
  action :nothing
  supports [:start, :stop, :restart, :reload]
end
