require 'chefspec'

describe 'ies-mysql::client' do
  let(:runner) do
    ChefSpec::Runner.new(:log_level => :error)
  end

  let(:chef_run) { runner.converge(described_recipe) }

  it 'the client' do
    expect(chef_run).to create_mysql_client('vagrant')
  end
end
