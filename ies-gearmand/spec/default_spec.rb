require_relative 'spec_helper.rb'

describe 'ies-gearmand::default' do
  let(:runner) { ChefSpec::Runner.new }
  let(:chef_run) { runner.converge(described_recipe) }
  let(:node) { runner.node }

  let(:default_file) { '/etc/default/gearman-job-server' }

  describe 'standard flow' do
    it 'discovers the ondreij repo' do
      expect(chef_run.node['php']['ppa']).to eq({
        'name' => 'ondrejphp',
        'package_prefix' => 'php5.6',
        'uri' => 'ppa:ondrej/php'
      })

      expect(chef_run).to include_recipe('php::dependencies-ppa')

      expect(chef_run).to add_apt_repository('ondrejphp')
        .with(
          :uri => 'ppa:ondrej/php'
        )
    end

    it 'installs gearman-job-server' do
      expect(chef_run).to install_package('gearman-job-server')
    end

    it 'includes the service recipe' do
      expect(chef_run).to include_recipe('ies-gearmand::service')
    end

    it 'installs defaults' do
      expect(chef_run).to create_template(default_file)
        .with(
          :cookbook => 'gearmand',
          :variables => {
            :port => 31_337,
            :log => '--syslog -l stderr'
          }
        )

      resource = chef_run.template(default_file)
      expect(resource).to notify('service[gearman-job-server]')
    end
  end
end
