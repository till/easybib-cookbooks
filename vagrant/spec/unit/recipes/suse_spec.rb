RSpec.describe 'vagrant::suse' do
  include_context 'mock vagrant_sha256sum'

  let(:chef_run) do
    ChefSpec::SoloRunner.new(
      platform: 'suse',
      version: '12.0',
      file_cache_path: '/var/tmp'
    ) do |node|
      node.set['vagrant']['version'] = '1.88.88'
    end.converge(described_recipe)
  end

  it 'includes the rhel platform family recipe' do
    expect(chef_run).to include_recipe('vagrant::rhel')
  end
end
