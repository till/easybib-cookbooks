RSpec.describe 'vagrant::mac_os_x' do
  include_context 'mock vagrant_sha256sum'

  let(:chef_run) do
    ChefSpec::SoloRunner.new(
      platform: 'mac_os_x',
      version: '10.10',
      file_cache_path: '/var/tmp'
    ) do |node|
      node.set['vagrant']['version'] = '1.88.88'
    end.converge(described_recipe)
  end

  it 'installs the downloaded package with the calculated source URI' do
    expect(chef_run).to install_dmg_package('Vagrant').with(
      source: 'https://releases.hashicorp.com/vagrant/1.88.88/vagrant_1.88.88.dmg'
    )
  end
end
