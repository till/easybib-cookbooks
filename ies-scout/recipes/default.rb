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

gem_package 'nokogiri' do
  options('--conservative --no-rdoc --no-ri')
  version '1.6.8.1'
  only_if node[:scout][:delete_on_shutdown] == true
end

include_recipe 'scout::default'
