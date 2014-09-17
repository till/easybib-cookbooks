apt_repository 'aptly' do
  uri          'http://repo.aptly.info/'
  distribution 'squeeze'
  components   ['main']
  keyserver    'keys.gnupg.net'
  key          '2A194991'
end

package 'aptly' do
  action :install
end

template '/etc/aptly.conf' do
  source 'aptly.conf.erb'
  owner 'root'
  group 'root'
  mode 00644
  variables(
    :root_dir => node['aptly']['mirror_dir'],
    :endpoint => node['aptly']['s3_mirror']
    )
  action :create
end
