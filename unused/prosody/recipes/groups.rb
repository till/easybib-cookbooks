groups_cfg = '/etc/prosody/conf.d/prosody_groups.cfg.lua'

execute 'load sharedgroups' do
  command "echo 'groups_file = \"/var/prosody/sharedgroups.txt\"' >> #{groups_cfg}"
  not_if do
    File.exist?(groups_cfg)
  end
end

template '/var/prosody/sharedgroups.txt' do
  source 'sharedgroups.txt.erb'
  owner 'prosody'
  group 'prosody'
  mode '0600'
  variables(
    :groups => node['prosody']['groups']
  )
  notifies :restart, 'service[prosody]'
end
