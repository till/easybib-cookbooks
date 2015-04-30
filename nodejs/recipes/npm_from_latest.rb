npm_bin = '/usr/bin/npm'

local_latest = "#{Chef::Config[:file_cache_path]}/install-npm.sh"

npm_version = node['nodejs']['npm']['version']

is_correct_version = ->(version) {
  `npm -v`.strip! == version
}

remote_file local_latest do
  source 'https://www.npmjs.org/install.sh'
  mode '0755'
  not_if do
    File.exist?(local_latest) || is_correct_version[npm_version]
  end
end

package "curl" do
  action :install
  only_if do
    File.exist?(local_latest)
  end
end

execute 'Install npm' do
  command local_latest
  environment({
    'clean' => 'no',
    'npm_install' => npm_version
  })
  not_if do
    is_correct_version[npm_version]
  end
end
