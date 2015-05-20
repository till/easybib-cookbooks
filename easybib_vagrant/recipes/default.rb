vagrant_user = node['easybib_vagrant']['environment']
home_dir = ::Dir.home(vagrant_user['user'])

['.config/easybib', '.ssh', '.vagrant.d'].each do |path|
  directory "#{home_dir}/#{path}" do
    mode 0700
    owner vagrant_user['user']
    group vagrant_user['group']
    recursive true
  end
end

include_recipe 'easybib_vagrant::cookbooks'
include_recipe 'easybib_vagrant::configure'
