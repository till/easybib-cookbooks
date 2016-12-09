apt_repository 'tideways' do
  uri          node['tideways']['repository']
  arch         'amd64'
  distribution 'debian'
  components   ['main']
  key          node['tideways']['key']
  keyserver    node['tideways']['keyserver']
end

packages = ['tideways-php', 'tideways-daemon', 'tideways-cli']

packages.each do |package_name|
  package package_name do
    version node['tideways']['version']
    action :install
  end
end

include_recipe 'tideways::configure'
