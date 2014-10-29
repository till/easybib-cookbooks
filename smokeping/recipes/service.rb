service 'smokeping' do
  action :nothing
  supports [:start, :stop, :status]
end
