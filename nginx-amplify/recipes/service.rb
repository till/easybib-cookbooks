service 'amplify-agent' do
  provider Chef::Provider::Service::Init
  supports [:start, :stop, :reload, :status, :restart]
end
