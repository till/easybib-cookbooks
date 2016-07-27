require 'chefspec'

describe 'fake-sqs::default' do
  let(:runner) do
    ChefSpec::Runner.new(:log_level => :error)
  end

  let(:chef_run) { runner.converge(described_recipe) }
  let(:chef_sqs) { '/opt/chef/embedded/bin/fake_sqs' }

  before do
    File.stub(:exist?).and_call_original
    File.stub(:exist?).with(chef_sqs).and_return(true)
  end

  it 'links fakesqs to /usr/local/bin' do
    link = chef_run.link('/usr/local/bin/fake_sqs')
    expect(link).to link_to(chef_sqs)
  end

  it 'it starts the fakesqs service via supervisord' do
    expect(chef_run).to enable_supervisor_service('fake_sqs')
  end

end
