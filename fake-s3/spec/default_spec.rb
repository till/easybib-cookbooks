require 'chefspec'

describe 'fake-s3::default' do
  let(:runner) do
    ChefSpec::Runner.new(:log_level => :error)
  end

  let(:chef_run) { runner.converge(described_recipe) }

  it 'installs the gem' do
    expect(chef_run).to install_gem_package('fakes3')
  end

  it 'it starts the fake-s3 service via supervisord' do
    expect(chef_run).to enable_supervisor_service('fakes3')
  end
end
