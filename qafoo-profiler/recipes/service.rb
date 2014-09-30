service 'qprofd' do
  service_name  'qprofd'
  supports     [:start, :stop, :reload, :restart]
end
