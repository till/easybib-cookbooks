app_dir = "#{Chef::Config[:file_cache_path]}/fauxton"

execute 'npm_install' do
  command 'npm install'
  cwd app_dir
  action :nothing
  notifies :run, 'execute[fauxton_deploy]'
end

execute 'fauxton_deploy' do
  command './node_modules/.bin/grunt couchapp_deploy'
  cwd app_dir
  action :nothing
end

git app_dir do
  repository node['apache-couchdb']['fauxton']['repository']
  revision node['apache-couchdb']['fauxton']['version']
  action :sync
  notifies :run, 'execute[npm_install]'
end
