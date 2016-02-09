RSpec.describe 'vagrant::fedora' do
  include_context 'mock vagrant_sha256sum'
  # include_context 'fedora runner'

  cached(:chef_run) do
    ChefSpec::SoloRunner.new(
      platform: 'fedora',
      version: '21',
      file_cache_path: '/var/tmp'
    ).converge(described_recipe)
  end

  it 'includes the rhel platform family recipe' do
    expect(chef_run).to include_recipe('vagrant::rhel')
  end
end
