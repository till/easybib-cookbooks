execute 'apt-get update' do
  command 'apt-get update'
end

execute "apt-get install #{node['ies-apt']['upgrade-package']}" do
  command "apt-get install -y #{node['ies-apt']['upgrade-package']}"
  not_if node['ies-apt']['upgrade-package'].nil?
end
