require 'chefspec'

describe 'fakesqs::default' do
  let(:runner) do
    ChefSpec::Runner.new(:log_level => :error)
  end

  let(:chef_run) { runner.converge(described_recipe) }

  it 'it starts the fakesqs service via supervisord' do
    expect(chef_run).to enable_supervisor_service('fake_sqs')
  end

end
