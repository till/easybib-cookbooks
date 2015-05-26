Chef::Log.info('No deploy user found. Skipping!') if node['bash']['environment']['user'].nil?
return if node['bash']['environment']['user'].nil?

include_recipe 'keychain'

home_dir = Dir.home(node['bash']['environment']['user'])

profile_file = "/usr/bin/keychain #{home_dir}/.ssh/id_dsa"
profile_file << "\n"
profile_file << "source #{home_dir}/.keychain/$HOSTNAME-sh"

file "#{home_dir}/.bash_profile" do
  content profile_file
  mode 0644
  owner node['bash']['environment']['user']
  group node['bash']['environment']['group']
end
