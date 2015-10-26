service 'statsd' do
  provider Chef::Provider::Service::Upstart
  supports [:start, :enable, :stop, :status]
end
