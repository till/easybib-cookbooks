require 'chefspec'

describe 'ies-mysql::default' do
  let(:runner) do
    ChefSpec::Runner.new
  end

  let(:chef_run) { runner.converge(described_recipe) }

  it 'it installs the server and the client' do
    expect(chef_run).to create_mysql_service('vagrant')
    expect(chef_run).to create_mysql_client('vagrant')
  end

  it 'it configures mysql' do
    expect(chef_run).to create_file_if_missing('/var/log/mysql/log-slow-queries.log')
    expect(chef_run).to create_mysql_config('vagrant-settings')
  end
end
