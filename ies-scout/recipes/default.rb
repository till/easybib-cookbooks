apt_repository 'scout' do
  key 'scout-archive.key'
  uri 'http://archive.scoutapp.com'
  components %w(ubuntu main)
end

user 'Add a user for scout' do
  home '/var/lib/scoutd'
  shell '/bin/sh'
  username 'scoutd'
end

node.normal['scout']['hostname'] = get_hostname(node)

include_recipe 'scout::default'
