vagrant_user = node['easybib_vagrant']['environment']
home_dir = vagrant_user['home']

template "#{home_dir}/.vagrant.d/Vagrantfile" do
  owner vagrant_user['user']
  group vagrant_user['group']
  source 'Vagrantfile.erb'
  mode 0644
end

node['easybib_vagrant']['plugins'].each do |plugin|
  execute "Install plugin: #{plugin}" do
    action :run
    command "vagrant plugin install #{plugin}"
    user vagrant_user['user']
    group vagrant_user['group']
    environment('HOME' => home_dir,
                'USER' => vagrant_user['user'])
  end
end

node.set['easybib_vagrant']['plugin_config']['bib-vagrant']['cookbook_path'] = generate_cookbook_path(home_dir, node)

template "#{home_dir}/.config/easybib/vagrantdefault.yml" do
  owner vagrant_user['user']
  group vagrant_user['user']
  source 'vagrantdefault.yml.erb'
  variables(
    :config => node['easybib_vagrant']['plugin_config']['bib-vagrant']
  )
end

template "#{home_dir}/.ssh/config" do
  owner vagrant_user['user']
  group vagrant_user['group']
  source 'ssh-config.erb'
  mode 0600
  variables(
    :is_opsworks => is_aws
  )
  only_if do
    is_aws
  end
end
