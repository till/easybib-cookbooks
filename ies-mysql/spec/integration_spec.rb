require 'chefspec'

# This is an integration test to ensure that future updates to
# the mysql cookbook which we wrap with ies-mysql, do not break
# our expectations.

describe 'ies-mysql::default' do
  let(:runner) do
    ChefSpec::Runner.new(
      :log_level => :error,
      :platform => 'ubuntu',
      :version => '16.04',
      :step_into => %w(mysql_service mysql_client)
    )
  end

  let(:chef_run) { runner.converge(described_recipe) }

  describe 'mysql 5.6 on Ubuntu 16.04' do
    before do
      stub_command('/usr/bin/test -f /var/lib/mysql-vagrant/mysql/user.frm').and_return(false)
    end

    it 'installs version 5.6 of the mysql-server and -client package' do
      expect(chef_run).to install_package('mysql-server-5.6')
      expect(chef_run).to install_package('mysql-client-5.6')
    end

    it 'uses upstart' do
      service = chef_run.mysql_service('vagrant')
      expect(service.provider).to eq(Chef::Provider::MysqlServiceUpstart)
    end
  end
end
