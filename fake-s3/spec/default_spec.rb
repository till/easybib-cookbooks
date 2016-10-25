require 'chefspec'

describe 'fake-s3::default' do
  let(:runner) do
    ChefSpec::SoloRunner.new(:log_level => :error)
  end

  let(:chef_run) { runner.converge(described_recipe) }
  let(:chef_s3) { '/opt/chef/embedded/bin/fakes3' }

  before do
    File.stub(:exist?).and_call_original
    File.stub(:exist?).with(chef_s3).and_return(true)
  end

  it 'installs the gem' do
    expect(chef_run).to install_gem_package('fakes3')
  end

  it 'links fakes3 to /usr/local/bin' do
    link = chef_run.link('/usr/local/bin/fakes3')
    expect(link).to link_to(chef_s3)
  end

  it 'it starts the fake-s3 service via supervisord' do
    expect(chef_run).to enable_supervisor_service('fakes3')
  end
end
