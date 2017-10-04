apt_repository 'scout' do
  key 'scout-archive.key'
  uri 'http://archive.scoutapp.com'
  components %w(ubuntu main)
  action :add
end

node.normal['scout']['hostname'] = get_hostname(node)

include_recipe 'scout::default'
