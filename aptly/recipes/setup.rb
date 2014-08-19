apt_repository 'aptly' do
  uri          'http://repo.aptly.info/'
  distribution 'squeeze'
  components   ['main']
  keyserver    'keys.gnupg.net'
  key          '2A194991'
end

package "aptly" do
  action :install
end
