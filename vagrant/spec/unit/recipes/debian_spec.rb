RSpec.describe 'vagrant::debian' do
  include_context 'mock vagrant_sha256sum'

  cached(:chef_run) do
    ChefSpec::SoloRunner.new(
      platform: 'ubuntu',
      version: '14.04',
      file_cache_path: '/var/tmp'
    ) do |node|
      node.set['vagrant']['version'] = '1.88.88'
    end.converge(described_recipe)
  end

  it 'downloads the package from the calculated URI' do
    expect(chef_run).to create_remote_file('/var/tmp/vagrant.deb').with(
      source: 'https://releases.hashicorp.com/vagrant/1.88.88/vagrant_1.88.88_x86_64.deb',
      checksum: 'abc123'
    )
  end

  it 'installs the downloaded package' do
    expect(chef_run).to install_dpkg_package('vagrant').with(
      source: '/var/tmp/vagrant.deb'
    )
  end
end
