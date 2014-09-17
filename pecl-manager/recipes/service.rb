service 'pecl-manager' do
  supports [:start, :stop, :restart, :status]
  action :nothing
end
