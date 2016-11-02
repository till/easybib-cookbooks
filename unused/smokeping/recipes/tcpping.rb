cookbook_file 'tcpping' do
  path   '/usr/bin/tcpping'
  mode   '0755'
  action :create_if_missing
end
