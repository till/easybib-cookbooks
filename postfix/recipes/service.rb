service 'postfix' do
  supports :status => true, :restart => true, :reload => true, :check => true
  action :enable
end
