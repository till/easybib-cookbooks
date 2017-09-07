apt_repository 'scout' do
  key 'scout-archive.key'
  uri 'http://archive.scoutapp.com'
  components %w(ubuntu main)
end

include_recipe 'scout::default'
