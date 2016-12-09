apt_repository 'tideways' do
  uri          node['tideways']['repository']
  arch         'amd64'
  distribution 'debian'
  components   ['main']
  key          node['tideways']['key']
  keyserver    node['tideways']['keyserver']
end

packages = {
  'tideways-php' => node['tideways']['php_version'],
  'tideways-daemon' => node['tideways']['daemon_version'],
  'tideways-cli' => nil
}

packages.each do |package_name, package_version|

  package_action = :upgrade
  unless package_version.nil?
    package_action = :install
  end

  package package_name do
    version package_version
    action package_action
  end
end

include_recipe 'tideways::configure'
