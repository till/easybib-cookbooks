require_relative 'spec_helper.rb'

describe 'php::module-opcache' do

  # runner needs to be separate here, bc we want to access node attrs in test below
  let(:runner)   { ChefSpec::Runner.new }
  let(:chef_run) { runner.converge(described_recipe) }
  let(:node)     { runner.node }

  describe 'install module with enabled error log' do
    let(:error_log) { '/some/path/file.log' }

    before do
      node.set['php-opcache']['settings']['error_log'] = 'BLA'
    end

    it 'adds ppa mirror configuration' do
      expect(chef_run).to include_recipe('php::dependencies-ppa')
    end

    it 'installs and configures the extension' do
      expect(chef_run).to install_php_ppa_package('opcache')
        .with(:config =>  node['php-opcache']['settings'])
    end

    it 'creates the logfile with correct permission' do
      expect(chef_run).to create_file('create opcache error_log')
        .with(:mode => 0755)
    end
  end

  describe 'install module with disabled error log' do
    it 'does not create the logfile' do
      expect(chef_run).not_to create_file('create opcache error_log')
    end
  end
end
