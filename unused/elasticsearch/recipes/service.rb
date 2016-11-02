service 'elasticsearch' do
  supports [:enable, :start, :stop, :restart]
  action   :nothing
end
