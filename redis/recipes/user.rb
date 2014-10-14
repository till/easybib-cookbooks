user node['redis']['user'] do
  shell  '/bin/false'
  action :create
  only_if do
    node['redis']['user'] != 'root'
  end
end
