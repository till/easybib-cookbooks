return if is_aws

execute "npm install -g bower@#{node['bower']['version']}"

path = "/home/#{node['bower']['user']}"

cookbook_file "#{path}/.bowerrc" do
  source 'bowerrc'
  owner node['bower']['user']
  group node['bower']['user']
  mode 0644
end
