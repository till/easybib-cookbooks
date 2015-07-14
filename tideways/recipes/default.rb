apt_repository 'tideways' do
  uri          node['tideways']['repository']
  arch         'amd64'
  distribution 'debian'
  components   ['main']
  key          node['tideways']['key']
end

packages = ['tideways-php', 'tideways-daemon']

packages.each do |package_name|
  package package_name do
    action :upgrade # install the latest
  end
end

include_recipe 'tideways::configure'
